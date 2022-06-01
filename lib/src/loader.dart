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
DynamicLibrary loadDynamicLibrary({required String libraryName, String? searchPath}) {
  late String libraryPath;

  // Get the platform specific file name
  String libraryFile = fullLibraryName(libraryName);

  // Build the dynamic library path from a search path or just a file name
  if (searchPath != null && searchPath.isNotEmpty) {
    // Early Exit if the desired search directory doesn't exist
    Directory directory = Directory(searchPath);
    if (!directory.existsSync()) {
      throw LoadDynamicLibraryException('Search Path directory does not exist\n\t'
          'Directory: ${directory.path}');
    }
    libraryPath = p.join(searchPath, libraryFile);
  } else {
    // Handle weird edge case where running Dart on Linux needs
    // The './' prepended to the dynamic library file name
    libraryPath = Platform.resolvedExecutable.endsWith('dart') && Platform.isLinux ? './$libraryFile' : libraryFile;
  }

  // Check to see that the Dynamic Library file exists before trying to load it
  if (!File(libraryPath).existsSync()) {
    throw LoadDynamicLibraryException('$libraryName cannot be found at the following location\n\t'
        'Library Name: $libraryName\n\t'
        'Current Directory: ${p.current} \n\t'
        'Desired Path: $libraryPath \n\t'
        'Resolved Full Path: ${p.absolute(libraryFile)}');
  }

  // Try loading the dynamic library
  try {
    return DynamicLibrary.open(libraryPath);
  } catch (e) {
    ProcessResult dependencyCheckResult = callOSDependencyCheck(libraryFile);
    throw LoadDynamicLibraryException('$libraryFile cannot be loaded. It may be missing dependencies\n\t'
        'Dependency Check Results [stderr]: ${dependencyCheckResult.stderr}\n\t'
        'Dependency Check Results [stdout]: ${dependencyCheckResult.stdout}');
  }
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
