import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as p;

/// The appropriate dynamic library file extension name for this platform
///
/// - Android: `.so`
/// - iOS: `.dylib`
/// - Linux: `.so`
/// - MacOS: `.dylib`
/// - Windows: `.dll`
String systemLibExtension() {
  return Platform.isWindows
      ? '.dll'
      : Platform.isMacOS || Platform.isIOS
      ? '.dylib'
      : '.so';
}

/// Get the default dynamic library prefix for this platform
///
/// - Windows: no prefix
/// - Unix based OSs: "lib" prefix
String libraryPrefix() => Platform.operatingSystem == 'windows' ? '' : 'lib';

/// Get the full dynamic library file name for this platform
String fullLibraryName(String name, {bool includePrefix = true}) =>
    (includePrefix ? libraryPrefix() : '') + name + systemLibExtension();

/// Whether this is being called by dart vs a compiled application
bool isDart() => p.basenameWithoutExtension(Platform.resolvedExecutable) == 'dart';

/// Resolve a library file to a full path, validating searchPath if provided.
String _resolveLibraryPath(String fileName, {String? searchPath}) {
  late String libraryPath;

  if (searchPath != null && searchPath.isNotEmpty) {
    Directory directory = Directory(searchPath);
    if (!directory.existsSync()) {
      throw LoadDynamicLibraryException('Search Path directory does not exist\n\tDirectory: ${directory.path}\n');
    }
    libraryPath = p.join(searchPath, fileName);
  } else {
    libraryPath = fileName;
  }

  libraryPath = isDart() ? p.absolute(libraryPath) : libraryPath;
  return libraryPath;
}

///
String fullLibraryPath(String libraryName, {String? searchPath, bool includePrefix = true}) {
  return _resolveLibraryPath(fullLibraryName(libraryName, includePrefix: includePrefix), searchPath: searchPath);
}

/// Try to open a dynamic library, throwing verbose diagnostics on failure.
DynamicLibrary _openWithDiagnostics({required String libraryPath, required String displayName, String? searchPath}) {
  try {
    return DynamicLibrary.open(libraryPath);
  } catch (e) {
    if (!File(libraryPath).existsSync()) {
      throw LoadDynamicLibraryException(
        '$displayName cannot be found at the following location\n'
        '\tSearch Path: $searchPath\n'
        '\tDesired Path: $libraryPath\n'
        '\tCurrent Directory: ${p.current}\n'
        '\tResolved Full Path: ${p.absolute(libraryPath)}\n',
      );
    }

    ProcessResult dependencyCheckResult = callOSDependencyCheck(libraryPath);

    throw LoadDynamicLibraryException(
      '$e\n\n'
      'Dependency Check:\n'
      '\tstderr: ${dependencyCheckResult.stderr}\n'
      '\tstdout: ${dependencyCheckResult.stdout}\n',
    );
  }
}

/// Load the dynamic library and throw more verbose exceptions to improve debugging
/// in cases where dynamic libraries exist but lack necessary dependencies
///
/// Note: We do not recommend using [searchPath] in Flutter applications due to the
/// implementation defined nuances in cross-platform development. If you bundle your dynamic
/// libraries in the correct location in your application, then you can find the dynamic library
/// with just `DynamicLibrary.open()` or `loadDynamicLibrary(libraryName: 'my_library')`
///
/// We recommend using [searchPath] instead for Dart applications, servers, micro-services,
/// where you have more control over the library locations
DynamicLibrary loadDynamicLibrary({required String libraryName, String? searchPath}) {
  String libraryPath = fullLibraryPath(libraryName, searchPath: searchPath);
  return _openWithDiagnostics(libraryPath: libraryPath, displayName: libraryName, searchPath: searchPath);
}

/// Loads a dynamic library using an explicit filename, bypassing platform
/// naming conventions. Use this for libraries with non-standard naming
/// (e.g., versioned Linux shared objects like 'libonnxruntime.so.1.23.2').
DynamicLibrary loadDynamicLibraryRaw({required String fileName, String? searchPath}) {
  String libraryPath = _resolveLibraryPath(fileName, searchPath: searchPath);
  return _openWithDiagnostics(libraryPath: libraryPath, displayName: fileName, searchPath: searchPath);
}

/// Call OS-specific CLI tools for resolving Dynamic Library Dependencies
///
/// - Windows: `dumpbin /DEPENDENTS [LIBRARY_PATH]`
/// - MacOS: `otool -L [LIBRARY_PATH]`
/// - Linux: `ldd [LIBRARY_PATH]`
ProcessResult callOSDependencyCheck(String libraryPath) {
  return Platform.isWindows
      ? Process.runSync('dumpbin', ['/DEPENDENTS', libraryPath])
      : Platform.isMacOS || Platform.isIOS
      ? Process.runSync('otool', ['-L', libraryPath])
      : Process.runSync('ldd', [libraryPath]);
}

/// Custom Exception class for errors that occur in [loadDynamicLibrary] function
class LoadDynamicLibraryException implements Exception {
  String cause;
  LoadDynamicLibraryException(this.cause);

  @override
  String toString() {
    return 'LoadDynamicLibrary Exception: $cause';
  }
}
