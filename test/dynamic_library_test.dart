import 'dart:io';

import 'package:dynamic_library/src/loader.dart';
import 'package:test/test.dart';

void main() {
  group('naming conventions', () {
    test('platform specific check - ${Platform.operatingSystem}', () {
      String libName = 'foo';

      if (Platform.isWindows) {
        expect(fullLibraryName(libName), 'foo.dll');
      } else if (Platform.isIOS || Platform.isMacOS) {
        expect(fullLibraryName(libName), 'libfoo.dylib');
      } else {
        expect(fullLibraryName(libName), 'libfoo.so');
      }
    });
  });
}
