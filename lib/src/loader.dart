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
String fullLibraryName(String name) => libraryPrefix() + name + systemLibExtension();

/// Load the dynamic library and throw more verbose exceptions to improve debugging
/// in cases where dynamic libraries exist but lack necessary dependencies
Future<DynamicLibrary> loadDynamicLibrary(String name) async {
  String libraryFile = fullLibraryName(name);
  bool fileExists = await File(name).exists();

  if (!fileExists) {
    throw Exception('loadDynamicLibrary Error: $libraryFile cannot be found\n'
        'Current Directory: ${p.current}'
        'Full Path Checked: ${p.absolute(libraryFile)}');
  }

  try {
    // Handle weird edge case where running Dart on Linux needs
    // The './' prepended to the dynamic library file name
    if (Platform.resolvedExecutable.endsWith('dart') && Platform.isLinux) {
      return DynamicLibrary.open('./$libraryFile');
    } else {
      return DynamicLibrary.open(libraryFile);
    }
  } catch (e) {
    ProcessResult dependencyCheckResult = await callOSDependencyCheck(libraryFile);
    throw Exception('loadDynamicLibrary Error: $libraryFile cannot be loaded, it may be missing some dependencies.\n'
        'Dependency Check Results [stderr]: ${dependencyCheckResult.stderr}\n'
        'Dependency Check Results [stdout]: ${dependencyCheckResult.stdout}\n');
  }
}

/// Call OS-specific tools for resolving Dynamic Library Dependencies
///
/// - Windows: `dumpbin /DEPENDENTS [LIBRARY_PATH]`
/// - MacOS: `otool -L [LIBRARY_PATH]`
/// - Linux: `ldd [LIBRARY_PATH]`
Future<ProcessResult> callOSDependencyCheck(libraryPath) async {
  return Platform.isWindows
      ? Process.run('otool', ['-L', libraryPath])
      : Platform.isMacOS || Platform.isIOS
          ? Process.run('dumpbin', ['/DEPENDENTS', libraryPath])
          : Process.run('ldd', [libraryPath]);
}
