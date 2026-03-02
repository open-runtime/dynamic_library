# Dynamic Library Core API Reference

This document covers the classes, exceptions, and top-level functions exported by the `dynamic_library` package.

## 1. Classes

### **DLib**
`class DLib`

DyLib class wrapper to bundle information about the loaded library with the library. This is useful if you need to keep the fully resolved location of a dynamic library.

- **Constructors**:
  - `DLib(String path, DynamicLibrary library)`: Builds a `DLib` instance which holds path information and the `DynamicLibrary` instance.

- **Properties**:
  - `DynamicLibrary library`: Access the dynamic library saved in this class.
  - `String path`: Get the full path to this loaded library.
  - `String extension`: Get the extension of the loaded library (e.g., `.so`, `.dylib`, `.dll`).
  - `String fileName`: Get the file name of the loaded library (strips the extension).

**Example:**
```dart
import 'dart:ffi';
import 'package:dynamic_library/dynamic_library.dart';

// Assuming you've already acquired a DynamicLibrary
// final DynamicLibrary dylib = loadDynamicLibrary(libraryName: 'my_library');
// final DLib dlib = DLib('/path/to/my_library.so', dylib);
```

### **LoadDynamicLibraryException**
`class LoadDynamicLibraryException implements Exception`

Custom Exception class for errors that occur in the `loadDynamicLibrary` and `loadDynamicLibraryRaw` functions.

- **Constructors**:
  - `LoadDynamicLibraryException(String cause)`: Initializes the exception with a specific cause.

- **Properties**:
  - `String cause`: String explaining the exception's cause.

- **Methods**:
  - `String toString()`: Returns a formatted exception string: `'LoadDynamicLibrary Exception: $cause'`.

## 2. Enums
*(No public enums defined in this module)*

## 3. Extensions
*(No public extensions defined in this module)*

## 4. Top-Level Functions

### **systemLibExtension**
`String systemLibExtension()`

The appropriate dynamic library file extension name for the current platform.
- Windows: `.dll`
- iOS / MacOS: `.dylib`
- Linux / Android: `.so`

### **libraryPrefix**
`String libraryPrefix()`

Get the default dynamic library prefix for the current platform.
- Windows: `''` (no prefix)
- Unix based OSs: `'lib'` prefix

### **fullLibraryName**
`String fullLibraryName(String name, {bool includePrefix = true})`

Get the full dynamic library file name for the current platform by combining the library prefix, the provided name, and the system library extension.

### **isDart**
`bool isDart()`

Returns `true` if the current script is being run directly via the `dart` executable (as opposed to a compiled Flutter application).

### **fullLibraryPath**
`String fullLibraryPath(String libraryName, {String? searchPath, bool includePrefix = true})`

Resolves the full path to a dynamic library, appending the correct prefix and extension based on the platform.

### **loadDynamicLibrary**
`DynamicLibrary loadDynamicLibrary({required String libraryName, String? searchPath})`

Load the dynamic library and throw more verbose exceptions (`LoadDynamicLibraryException`) to improve debugging in cases where dynamic libraries exist but lack necessary dependencies.

**Example:**
```dart
import 'dart:ffi';
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  try {
    DynamicLibrary lib = loadDynamicLibrary(libraryName: 'my_library');
  } catch (e) {
    print(e.toString());
  }
}
```

### **loadDynamicLibraryRaw**
`DynamicLibrary loadDynamicLibraryRaw({required String fileName, String? searchPath})`

Loads a dynamic library using an explicit filename, bypassing platform naming conventions. Use this for libraries with non-standard naming (e.g., versioned Linux shared objects like `'libonnxruntime.so.1.23.2'`).

### **callOSDependencyCheck**
`ProcessResult callOSDependencyCheck(String libraryPath)`

Call OS-specific CLI tools for resolving Dynamic Library Dependencies:
- Windows: `dumpbin /DEPENDENTS [LIBRARY_PATH]`
- MacOS: `otool -L [LIBRARY_PATH]`
- Linux: `ldd [LIBRARY_PATH]`

### **flutterAssetsDirectory**
`String flutterAssetsDirectory({bool localDebugMode = false})`

Resolves the directory path for Flutter assets, accounting for differences between local debug mode and bundled application builds on macOS.

### **defaultLibraryDirectory**
`String defaultLibraryDirectory({bool localDebugMode = false})`

Returns the default location from which dynamic libraries are loaded to be used as the search path of library resolution.

### **frbDynamicLibraryName**
`String frbDynamicLibraryName(String packageName)`

Build the platform-correct dynamic library filename for a Flutter Rust Bridge (FRB) package, accounting for the FRB convention where macOS libraries are NOT prefixed with `lib` (e.g. `runtime_native_audio.dylib`), while Linux libraries ARE prefixed (e.g. `libruntime_native_audio.so`).

### **frbFullLibraryPath**
`String frbFullLibraryPath(String packageName)`

Resolve the full path for an FRB dynamic library. Calls `fullLibraryPath` and then applies the macOS prefix-strip workaround.

### **initializeFrbLibrary**
`Future<void> initializeFrbLibrary({required String packageName, required Future<void> Function({required ExternalLibrary externalLibrary}) rustLibInit, String? libPath, ByteData? libBytes, Directory? libBytesCacheDir, bool assumeLocalResolution = true})`

Initialize a Flutter Rust Bridge library by package name. This is the single entry point that replaces duplicated initialization logic across all FRB packages.

It handles parameter validation, local resolution, byte-based resolution, explicit path resolution, system resolution, and the macOS `lib` prefix workaround.


**Example:**
```dart
import 'dart:io';
import 'dart:typed_data';
import 'package:dynamic_library/dynamic_library.dart';

// Assuming you have a generated FRB file with `RustLib.init`
// import 'rust/generated/frb_generated.dart' show RustLib;

Future<void> initMyLib() async {
  // await initializeFrbLibrary(
  //   packageName: 'my_rust_package',
  //   rustLibInit: RustLib.init, 
  //   assumeLocalResolution: true,
  // );
}
```
