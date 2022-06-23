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

/// Whether this is being called by dart vs a compiled application
bool isDart() => p.basenameWithoutExtension(Platform.resolvedExecutable) == 'dart';

///
String fullLibraryPath(String libraryName, {String? searchPath}) {
  late String libraryPath;

  // Get the platform specific file name
  String libraryFile = fullLibraryName(libraryName);

  // Build the dynamic library path from a search path or just a file name
  if (searchPath != null && searchPath.isNotEmpty) {
    // Early Exit if the desired search directory doesn't exist
    Directory directory = Directory(searchPath);
    if (!directory.existsSync()) {
      throw LoadDynamicLibraryException('Search Path directory does not exist\n\tDirectory: ${directory.path}\n');
    }
    libraryPath = p.join(searchPath, libraryFile);
  } else {
    libraryPath = libraryFile;
  }

  // Use absolute paths on dart runtimes (instead of flutter applications)
  libraryPath = isDart() ? p.absolute(libraryPath) : libraryPath;
  return libraryPath;
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
  // Get the full library path
  String libraryPath = fullLibraryPath(libraryName, searchPath: searchPath);

  try {
    return DynamicLibrary.open(libraryPath);
  } catch (e) {
    // Try to check to see if the file just doesn't exist at this location
    if (!File(libraryPath).existsSync()) {
      throw LoadDynamicLibraryException('$libraryName cannot be found at the following location\n'
          '\tSearch Path: $searchPath\n'
          '\tDesired Path: $libraryPath\n'
          '\tCurrent Directory: ${p.current}\n'
          '\tResolved Full Path: ${p.absolute(libraryPath)}\n');
    }

    ProcessResult dependencyCheckResult = callOSDependencyCheck(libraryPath);

    throw LoadDynamicLibraryException('$e\n\n'
        'Dependency Check:\n'
        '\tstderr: ${dependencyCheckResult.stderr}\n'
        '\tstdout: ${dependencyCheckResult.stdout}\n');
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
