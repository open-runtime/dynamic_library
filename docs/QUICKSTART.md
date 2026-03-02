# Quickstart

## 1. Overview
The Dynamic Library Core module provides robust utilities for resolving, loading, and diagnosing platform-specific dynamic libraries (`.so`, `.dylib`, `.dll`) in both pure Dart and Flutter applications. It streamlines Foreign Function Interface (FFI) initialization with advanced diagnostics for missing dependencies, and offers specialized resolution support for Flutter Rust Bridge (FRB) integrations.

## 2. Import
Import the core library to access all available loader functions, exceptions, and wrapper classes:

```dart
import 'package:dynamic_library/dynamic_library.dart';
```

*(Note: You will also typically need to import `dart:ffi` to work with the resulting `DynamicLibrary` objects).*

## 3. Setup
This module provides static utility functions rather than requiring a global instance or configuration. You can directly call `loadDynamicLibrary` for standard FFI, or `initializeFrbLibrary` for setting up a Flutter Rust Bridge package. 

Errors during initialization are raised as a `LoadDynamicLibraryException`, which includes OS-specific dependency checks (e.g., `otool`, `ldd`, or `dumpbin`) to help you debug missing system dependencies.

## 4. Common Operations

### Loading a Standard Dynamic Library
Automatically resolves the correct OS prefix (`lib`) and extension (`.so`, `.dylib`, `.dll`) and returns a `DynamicLibrary`.

```dart
import 'dart:ffi';
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  try {
    // Resolves to libmy_c_lib.so, libmy_c_lib.dylib, or my_c_lib.dll
    DynamicLibrary myLib = loadDynamicLibrary(libraryName: 'my_c_lib');
    print('Library loaded successfully!');
  } on LoadDynamicLibraryException catch (e) {
    print('Failed to load: $e');
  }
}
```

### Loading a Library with an Exact Filename
Useful for versioned Linux shared objects or when bypassing OS-specific naming conventions.

```dart
import 'dart:ffi';
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  // Use `searchPath` to define exactly where to look (recommended for Dart CLI/Servers)
  try {
    DynamicLibrary onnxLib = loadDynamicLibraryRaw(
      fileName: 'libonnxruntime.so.1.23.2',
      searchPath: '/opt/local/lib',
    );
    print('Library loaded: $onnxLib');
  } on LoadDynamicLibraryException catch (e) {
    print('Failed to load: $e');
  }
}
```

### Wrapping a Library with `DLib`
Bundle path metadata with the `DynamicLibrary` instance using the `DLib` wrapper class.

```dart
import 'dart:ffi';
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  DynamicLibrary ffiLib = loadDynamicLibrary(libraryName: 'example');
  
  // Keep track of the resolved location and file extensions
  DLib wrappedLib = DLib('/absolute/path/to/libexample.so', ffiLib);

  print('Loaded library: ${wrappedLib.library}');
  print('Loaded absolute path: ${wrappedLib.path}');
  print('Loaded extension: ${wrappedLib.extension}');
  print('Loaded file name: ${wrappedLib.fileName}');
}
```

### Initializing a Flutter Rust Bridge (FRB) Library
A dedicated entry point to replace duplicated init logic across FRB packages, accounting for macOS prefix-strip workarounds and caching.

```dart
import 'dart:io';
import 'dart:typed_data';
import 'package:dynamic_library/dynamic_library.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart' show ExternalLibrary;

// Note: Replace with your actual generated FRB file
// import 'rust/generated/frb_generated.dart' show RustLib;

bool _isInitialized = false;

Future<void> initializeMyFrbApp({
  String? libPath,
  ByteData? libBytes,
  Directory? libBytesCacheDir,
  bool assumeLocalResolution = true,
}) async {
  if (_isInitialized) return;
  
  await initializeFrbLibrary(
    packageName: 'runtime_native_audio',
    // rustLibInit: RustLib.init, // The generated package init function
    rustLibInit: ({required ExternalLibrary externalLibrary}) async {
       // Mock initialization for example
    },
    libPath: libPath,
    libBytes: libBytes,
    libBytesCacheDir: libBytesCacheDir,
    assumeLocalResolution: assumeLocalResolution, 
  );
  
  _isInitialized = true;
}
```

## 5. Advanced Utility Functions

The library provides several helper methods to assist with path resolution and platform checks:

### Platform & Name Resolution
```dart
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  // Get the appropriate dynamic library file extension (.so, .dylib, .dll)
  print(systemLibExtension());

  // Get the default dynamic library prefix (e.g., 'lib' or '')
  print(libraryPrefix());

  // Get the full dynamic library file name (e.g., 'libexample.so')
  print(fullLibraryName('example'));
  
  // Resolve the full absolute path for a library
  print(fullLibraryPath('example', searchPath: '/opt/local/lib'));
}
```

### Flutter Rust Bridge (FRB) Specific Helpers
These helpers account for the FRB convention where macOS libraries are not prefixed with `lib` (e.g., `runtime_native_audio.dylib` instead of `libruntime_native_audio.dylib`).

```dart
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  // Get the FRB-specific dynamic library name
  print(frbDynamicLibraryName('runtime_native_audio'));
  
  // Get the FRB-specific full library path
  print(frbFullLibraryPath('runtime_native_audio'));
}
```

### Environment Checks & Diagnostics
```dart
import 'dart:io';
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  // Check if running in pure Dart vs compiled application
  if (isDart()) {
    print('Running in a Dart VM environment.');
  }

  // Call OS-specific CLI tools (dumpbin, otool, ldd) to check dependencies
  ProcessResult result = callOSDependencyCheck('/path/to/libexample.so');
  print(result.stdout);
}
```

## 6. Configuration
The library relies on arguments passed directly to its functions:
- **`searchPath`**: Optional parameter in `loadDynamicLibrary` and `loadDynamicLibraryRaw`. Highly recommended for pure Dart apps/micro-services where you control the directory structure. **Not recommended** for Flutter apps due to cross-platform bundling nuances.
- **`assumeLocalResolution`**: Boolean parameter in `initializeFrbLibrary` (defaults to `true`). When `true`, it resolves relative to `Directory.current` (ideal for `dart run`). When `false`, it uses system resolution, or explicit paths via `libPath` or `libBytes`.
- **`libBytes` & `libBytesCacheDir`**: Allows loading an FRB library directly from raw bytes (e.g., extracted from a Flutter asset bundle) by caching it to disk first.

## 7. Related Modules
- **`dart:ffi`**: The standard Dart Foreign Function Interface library.
- **`flutter_rust_bridge`**: Used heavily with `initializeFrbLibrary` to load generated Rust bindings.
