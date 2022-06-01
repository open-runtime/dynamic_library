import 'package:dynamic_library/src/loader.dart';

void main() {
  String dynamicLibraryName = 'foo';
  print('Dynamic library to load: \'$dynamicLibraryName\'');
  print('Looking for library with name: \'${fullLibraryName(dynamicLibraryName)}\'');
}
