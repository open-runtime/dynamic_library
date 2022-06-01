import 'dart:io';

import 'package:dynamic_library/src/loader.dart';

void main() {
  // Get the full file name
  String dynamicLibrary = 'foo';
  String libraryFileName = fullLibraryName(dynamicLibrary);
  print('Dynamic library to load: \'$dynamicLibrary\'');
  print('Looking for library with name: \'$libraryFileName\'\n');

  // This will fail to the load the library because the file doesn't exist
  try {
    print('Try loading the dynamic library');
    loadDynamicLibrary(libraryName: dynamicLibrary);
  } catch (e) {
    print('$e\n');
  }

  // This will fail to the load the library because the directtory doesn't exist
  try {
    print('Try loading the dynamic library with a directory search path');
    loadDynamicLibrary(libraryName: dynamicLibrary, searchPath: '/path/to/nowhere');
  } catch (e) {
    print('$e\n');
  }

  // This will call the dynamic library dependency check
  ProcessResult result = callOSDependencyCheck('foo');
  print('result.stderr: ${result.stderr}\nresult.stdout: ${result.stdout}\n');
}
