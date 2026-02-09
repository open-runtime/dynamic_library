import 'dart:ffi' show Abi;
import 'dart:io' show Directory, File, Platform;
import 'dart:typed_data' show ByteData;

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart' show ExternalLibrary;

import 'loader.dart' show fullLibraryPath;

// ─────────────────────────────────────────────────────────────────────────────
// Tier A: Helpers (building blocks)
// ─────────────────────────────────────────────────────────────────────────────

/// Build the platform-correct dynamic library filename for an FRB package.
///
/// Unlike the generic [fullLibraryName] in `loader.dart`, this function
/// accounts for the FRB convention where macOS libraries are NOT prefixed
/// with `lib` (e.g. `runtime_native_audio.dylib`), while Linux libraries
/// ARE prefixed (e.g. `libruntime_native_audio.so`).
///
/// Returns an empty string if the current platform/architecture is not
/// recognized -- callers should handle this as an error.
String frbDynamicLibraryName(String packageName) {
  if (Abi.current() == Abi.macosArm64) return '$packageName.dylib';
  if (Abi.current() == Abi.macosX64) return '$packageName.dylib';
  if (Abi.current() == Abi.windowsX64) return '$packageName.dll';
  if (Platform.isLinux) return 'lib$packageName.so';
  return '';
}

/// Resolve the full path for an FRB dynamic library.
///
/// Calls [fullLibraryPath] and then applies the macOS prefix-strip workaround:
/// `fullLibraryPath` prepends `lib` on all Unix-like systems, but on macOS our
/// FRB libraries are NOT prefixed. On Linux they ARE prefixed, so no stripping
/// is needed.
String frbFullLibraryPath(String packageName) {
  String path = fullLibraryPath(packageName);
  final String dylibName = frbDynamicLibraryName(packageName);

  if (Platform.isMacOS) {
    path = path.replaceFirst('lib$dylibName', dylibName);
  }

  return path;
}

// ─────────────────────────────────────────────────────────────────────────────
// Tier B: High-level init function
// ─────────────────────────────────────────────────────────────────────────────

/// Initialize a Flutter Rust Bridge library by package name.
///
/// This is the single entry point that replaces the duplicated init logic
/// across all FRB packages. It handles:
///
/// - Parameter validation
/// - Local resolution (for `dart run` development)
/// - Byte-based resolution (for Flutter asset bundles)
/// - Explicit path resolution (for direct file paths)
/// - System resolution via [fullLibraryPath] (for production app bundles)
/// - The macOS `lib` prefix workaround
///
/// Parameters:
/// - [packageName]: The package name, e.g. `'runtime_native_audio'`
/// - [rustLibInit]: The package's `RustLib.init` function reference
/// - [libPath]: Explicit path to the dynamic library file
/// - [libBytes]: Raw bytes of the dynamic library (e.g. from an asset bundle)
/// - [libBytesCacheDir]: Directory to cache [libBytes] on disk
/// - [assumeLocalResolution]: When `true` (default), resolves the library
///   relative to `Directory.current` (for `dart run`). When `false`, uses
///   system resolution or an explicit path/bytes.
///
/// Example usage in a package's `init.dart`:
/// ```dart
/// import 'package:dynamic_library/dynamic_library.dart';
/// import 'rust/generated/frb_generated.dart' show RustLib;
///
/// const String PACKAGE_NAME = 'runtime_native_audio';
/// String get DYNAMIC_LIBRARY_NAME => frbDynamicLibraryName(PACKAGE_NAME);
///
/// bool _isInitialized = false;
///
/// Future<void> initialize({
///   String? libPath,
///   ByteData? libBytes,
///   Directory? libBytesCacheDir,
///   bool assumeLocalResolution = true,
/// }) async {
///   if (_isInitialized) return;
///   await initializeFrbLibrary(
///     packageName: PACKAGE_NAME,
///     rustLibInit: RustLib.init,
///     libPath: libPath,
///     libBytes: libBytes,
///     libBytesCacheDir: libBytesCacheDir,
///     assumeLocalResolution: assumeLocalResolution,
///   );
///   _isInitialized = true;
/// }
/// ```
Future<void> initializeFrbLibrary({
  required String packageName,
  required Future<void> Function({required ExternalLibrary externalLibrary}) rustLibInit,
  String? libPath,
  ByteData? libBytes,
  Directory? libBytesCacheDir,
  bool assumeLocalResolution = true,
}) async {
  // ── Parameter validation ──
  if (libPath is String && assumeLocalResolution) {
    throw ArgumentError(
      'When passing in a libPath, assumeLocalResolution must explicitly be set to false.',
    );
  }
  if (libBytes != null && assumeLocalResolution) {
    throw ArgumentError(
      'When passing in libBytes, assumeLocalResolution must explicitly be set to false.',
    );
  }
  if (libBytes != null && libBytesCacheDir is! Directory) {
    throw ArgumentError(
      'When passing in libBytes, libBytesCacheDir must be set and '
      'assumeLocalResolution must explicitly be set to false.',
    );
  }

  // ── Resolve the library file ──
  File? file;
  final String fileName = frbDynamicLibraryName(packageName);
  final String slash = Platform.pathSeparator;

  if (assumeLocalResolution) {
    // Local resolution: look for the dylib in the standard FRB build output path
    // relative to the current working directory (for `dart run` development).
    final List<String> rootSegments = [
      Directory.current.path,
      'lib',
      'src',
      'ffi',
      'io',
      'rust',
      'generated',
      'io',
      Abi.current().toString(),
    ];
    file = File([...rootSegments, fileName].join(slash));
    file.existsSync() ||
        (throw ArgumentError(
          'The file at ${file.absolute.path} does not exist. '
          'Ensure you have run utils/build.dart before trying to use the library from source.',
        ));
  } else if (libBytes is ByteData) {
    // Byte-based resolution: write the library bytes to a cache directory and load from there.
    if (libBytesCacheDir is! Directory) {
      throw ArgumentError('When passing in libBytes, libBytesCacheDir must be set.');
    }
    file = File([libBytesCacheDir.path, fileName].join(slash));
    if (!await file.exists()) await file.create(recursive: false);
    await file.writeAsBytes(libBytes.buffer.asUint8List(), flush: true);
  } else if (libPath is String) {
    // Explicit path resolution: load from the given path directly.
    file = File(libPath);
    file.existsSync() || (throw ArgumentError('The file at $libPath does not exist.'));
  } else {
    // System resolution: use fullLibraryPath with the macOS prefix-strip workaround.
    // This resolves to the app bundle's Frameworks directory on macOS or system library
    // paths on Linux. We don't check for file existence here because ExternalLibrary.open
    // will check multiple locations; allow it to throw if the library cannot be resolved.
    file = File(frbFullLibraryPath(packageName));
  }

  // ── Load the library via FRB ──
  await rustLibInit(externalLibrary: ExternalLibrary.open(file.path)).catchError((e) => throw e);
}
