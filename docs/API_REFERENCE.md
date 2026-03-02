# Dynamic Library Core API Reference

The `dynamic_library` package provides robust and platform-aware utilities for loading dynamic libraries (`.so`, `.dylib`, `.dll`) in both pure Dart and Flutter applications.

## 1. Classes

### **DLib**
DyLib class wrapper to bundle information about the loaded library with the library. This is useful if you need to keep the fully resolved location of a dynamic library.

*   **Properties**
    *   `DynamicLibrary get library`: Access the dynamic library saved in this class.
    *   `String get path`: Get the full path to this loaded library.
    *   `String get extension`: Get the extension of the loaded library.
    *   `String get fileName`: Get the file name of the loaded library (strips the extension).

*   **Constructors**
    *   `const DLib(String _path, DynamicLibrary _library)`: Constructor, builds Dlib class which holds path information and the Library.

### **LoadDynamicLibraryException**
Custom Exception class for errors that occur in `loadDynamicLibrary` function. Contains verbose diagnostics to help track down missing dependencies or incorrect paths.

*   **Fields**
    *   `String cause`: The reason the exception was thrown.

*   **Methods**
    *   `String toString()`: Returns a formatted string representation of the exception.

*   **Constructors**
    *   `LoadDynamicLibraryException(String cause)`: Creates a new exception with the given cause.

## 2. Top-Level Functions

### **initializeFrbLibrary**
```dart
Future<void> initializeFrbLibrary({
  required String packageName,
  required Future<void> Function({required ExternalLibrary externalLibrary}) rustLibInit,
  String? libPath,
  ByteData? libBytes,
  Directory? libBytesCacheDir,
  bool assumeLocalResolution = true,
})
```
Initialize a Flutter Rust Bridge library by package name.

This is the single entry point that replaces the duplicated init logic across all FRB packages. It handles:
- Parameter validation
- Local resolution (for `dart run` development)
- Byte-based resolution (for Flutter asset bundles)
- Explicit path resolution (for direct file paths)
- System resolution via `fullLibraryPath` (for production app bundles)
- The macOS `lib` prefix workaround

**Example Usage in an FRB Package:**
```dart
import 'dart:io' show Directory;
import 'dart:typed_data' show ByteData;
import 'package:dynamic_library/dynamic_library.dart';

// Note: 'rust/generated/frb_generated.dart' is specific to the consumer package
// import 'rust/generated/frb_generated.dart' show RustLib;

const String packageName = 'runtime_native_audio';

bool _isInitialized = false;

Future<void> initialize({
  String? libPath,
  ByteData? libBytes,
  Directory? libBytesCacheDir,
  bool assumeLocalResolution = true,
}) async {
  if (_isInitialized) return;
  
  await initializeFrbLibrary(
    packageName: packageName,
    // rustLibInit: RustLib.init,
    // Provide your actual initialization function reference here
    rustLibInit: ({required externalLibrary}) async {},
    libPath: libPath,
    libBytes: libBytes,
    libBytesCacheDir: libBytesCacheDir,
    assumeLocalResolution: assumeLocalResolution,
  );
  
  _isInitialized = true;
}
```

### **loadDynamicLibrary**
```dart
DynamicLibrary loadDynamicLibrary({required String libraryName, String? searchPath})
```
Load the dynamic library and throw more verbose exceptions (`LoadDynamicLibraryException`) to improve debugging in cases where dynamic libraries exist but lack necessary dependencies.

**Note:** We do not recommend using `searchPath` in Flutter applications due to the implementation defined nuances in cross-platform development. If you bundle your dynamic libraries in the correct location in your application, then you can find the dynamic library with just `DynamicLibrary.open()` or `loadDynamicLibrary(libraryName: 'my_library')`. We recommend using `searchPath` instead for Dart applications, servers, micro-services, where you have more control over the library locations.

### **loadDynamicLibraryRaw**
```dart
DynamicLibrary loadDynamicLibraryRaw({required String fileName, String? searchPath})
```
Loads a dynamic library using an explicit filename, bypassing platform naming conventions. Use this for libraries with non-standard naming (e.g., versioned Linux shared objects like `libonnxruntime.so.1.23.2`).

### **frbDynamicLibraryName**
```dart
String frbDynamicLibraryName(String packageName)
```
Build the platform-correct dynamic library filename for an FRB package. Accounts for the FRB convention where macOS libraries are NOT prefixed with `lib` (e.g. `runtime_native_audio.dylib`), while Linux libraries ARE prefixed (e.g. `libruntime_native_audio.so`). Returns an empty string if the current platform/architecture is not recognized.

### **frbFullLibraryPath**
```dart
String frbFullLibraryPath(String packageName)
```
Resolve the full path for an FRB dynamic library. Calls `fullLibraryPath` and then applies the macOS prefix-strip workaround.

### **systemLibExtension**
```dart
String systemLibExtension()
```
Returns the appropriate dynamic library file extension name for this platform (`.so` for Linux/Android, `.dylib` for macOS/iOS, `.dll` for Windows).

### **libraryPrefix**
```dart
String libraryPrefix()
```
Returns the default dynamic library prefix for this platform (no prefix on Windows, `lib` on Unix-based OSs).

### **fullLibraryName**
```dart
String fullLibraryName(String name)
```
Returns the full dynamic library file name for this platform.

### **isDart**
```dart
bool isDart()
```
Returns whether this is being called by dart vs a compiled application.

### **fullLibraryPath**
```dart
String fullLibraryPath(String libraryName, {String? searchPath})
```
Resolves a library file to a full path, validating `searchPath` if provided.

### **callOSDependencyCheck**
```dart
ProcessResult callOSDependencyCheck(String libraryPath)
```
Call OS-specific CLI tools for resolving Dynamic Library Dependencies (`dumpbin /DEPENDENTS` on Windows, `otool -L` on MacOS/iOS, `ldd` on Linux).
