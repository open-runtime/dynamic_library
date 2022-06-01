import 'package:dynamic_library/src/loader.dart';

void main() {
  String dynamicLibrary = 'foo';
  print('Dynamic library to load: \'$dynamicLibrary\'');
  print('Looking for library with name: \'${fullLibraryName(dynamicLibrary)}\'');

  // This will fail to the load the library because the file doesn't exist
  // try {
  //   print('Try loading the dynamic library');
  //   loadDynamicLibrary(libraryName: dynamicLibrary);
  // } catch (e) {
  //   print(e);
  // }

  // This will fail to the load the library because the directtory doesn't exist
  try {
    print('Try loading the dynamic library with a directory search path');
    loadDynamicLibrary(libraryName: dynamicLibrary, searchPath: '/path/to/nowhere');
  } catch (e) {
    print(e);
  }
}
