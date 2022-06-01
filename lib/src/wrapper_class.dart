import 'dart:ffi';
import 'package:path/path.dart' as p;

/// DyLib class wrapper to bundle information about the loaded library with the library. This
/// is useful if you need to keep the fully resolved location of a dynamic library
///
class DLib {
  final String _path;
  final DynamicLibrary _library;

  /// Constructor, builds Dlib class which holds path information and the Library
  const DLib(this._path, this._library);

  /// Access the dynamic library save in this class
  DynamicLibrary get library => _library;

  /// Get the full path to this loaded library
  String get path => _path;

  /// Get the extension of the loaded library
  String get extension => p.extension(_path);

  /// Get the file name of the loaded library (strips the extension)
  String get fileName => p.basename(_path);
}
