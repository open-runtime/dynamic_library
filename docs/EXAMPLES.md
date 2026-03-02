# Dynamic Library Core Examples

This document provides practical, copy-paste-ready examples for using the `dynamic_library` package. It covers basic loading, integrating with Flutter Rust Bridge (FRB), error handling, and advanced usage.

## 1. Basic Usage

### Loading a Standard Dynamic Library

Use `loadDynamicLibrary` to load a library by its base name. The package automatically resolves the correct prefix (e.g., `lib`) and extension (e.g., `.so`, `.dylib`, `.dll`) based on the current platform.

```dart
import 'dart:ffi';
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  // On Windows: loads "my_core.dll"
  // On macOS/iOS: loads "libmy_core.dylib"
  // On Linux/Android: loads "libmy_core.so"
  try {
    final DynamicLibrary myLib = loadDynamicLibrary(libraryName: 'my_core');
    print('Successfully loaded library: $myLib');
  } catch (e) {
    print('Failed to load library: $e');
  }
}
```

### Working with the `DLib` Wrapper

The `DLib` class allows you to bundle the resolved path information alongside the `DynamicLibrary` instance, which is helpful for debugging or logging.

```dart
import 'dart:ffi';
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  const String libraryName = 'math_operations';
  
  // Resolve the full path first
  final String path = fullLibraryPath(libraryName);
  
  try {
    // Load the library
    final DynamicLibrary library = loadDynamicLibrary(libraryName: libraryName);
    
    // Create the wrapper
    final DLib dLib = DLib(path, library);
    
    // Access information
    print('Loaded: ${dLib.fileName}');
    print('Full Path: ${dLib.path}');
    print('Extension: ${dLib.extension}');
    
    // Use the underlying library
    // dLib.library.lookupFunction<...>();
  } on LoadDynamicLibraryException catch(e) {
    print('Could not load library: ${e.cause}');
  }
}
```

### Utility Functions for Platform Introspection

You can use utility functions to understand how the package formats library names on the current platform.

```dart
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  print('System Extension: ${systemLibExtension()}');
  print('Library Prefix: ${libraryPrefix()}');
  print('Formatted Name: ${fullLibraryName('audio_engine')}');
  print('Is running via Dart CLI: ${isDart()}');
}
```

## 2. Common Workflows

### Initializing a Flutter Rust Bridge (FRB) Library

When using `flutter_rust_bridge`, `initializeFrbLibrary` provides a unified entry point that handles local resolution during development (`dart run`), system/byte resolution during production, and explicit path resolution.

#### Development Mode (Local Resolution)

```dart
import 'dart:io';
import 'dart:typed_data';
import 'package:dynamic_library/dynamic_library.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';

// Assume this is the generated init function from FRB
Future<void> mockRustLibInit({required ExternalLibrary externalLibrary}) async {
  print('Rust library initialized with: $externalLibrary');
}

void main() async {
  const String packageName = 'runtime_native_audio';
  
  try {
    // Development mode: Uses local resolution (relative to Directory.current)
    await initializeFrbLibrary(
      packageName: packageName,
      rustLibInit: mockRustLibInit,
      assumeLocalResolution: true, // Typically true during 'dart run'
    );
    print('FRB Library initialized successfully in local mode.');
  } catch (e) {
    print('Failed to initialize local FRB library: $e');
  }
}
```

#### Production Mode (Explicit File Path)

You can specify an exact path to the library. When doing so, you must set `assumeLocalResolution: false`.

```dart
import 'package:dynamic_library/dynamic_library.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';

// Assume this is the generated init function from FRB
Future<void> mockRustLibInit({required ExternalLibrary externalLibrary}) async {
  print('Rust library initialized with: $externalLibrary');
}

void main() async {
  final String explicitPath = fullLibraryPath('runtime_native_audio', searchPath: '/opt/my_app/lib');

  try {
    await initializeFrbLibrary(
      packageName: 'runtime_native_audio',
      rustLibInit: mockRustLibInit,
      libPath: explicitPath,
      assumeLocalResolution: false, // Required when providing libPath
    );
    print('FRB Library initialized from explicit path.');
  } catch (e) {
    print('Failed to initialize FRB library from explicit path: $e');
  }
}
```

### Loading Libraries in a specific Search Path

For Dart CLI apps, servers, or microservices, you might want to specify an explicit directory where your `.so`, `.dll`, or `.dylib` files are located.

```dart
import 'dart:ffi';
import 'dart:io';
import 'package:dynamic_library/dynamic_library.dart';
import 'package:path/path.dart' as p;

void main() {
  // Define a custom search directory relative to the script
  final String customSearchPath = p.join(Directory.current.path, 'compiled_libs');
  
  try {
    // This will look for the library specifically in the customSearchPath
    final DynamicLibrary customLib = loadDynamicLibrary(
      libraryName: 'custom_service',
      searchPath: customSearchPath,
    );
    
    print('Successfully loaded library from custom path.');
  } on LoadDynamicLibraryException catch (e) {
    print('Library could not be loaded: ${e.cause}');
  }
}
```

## 3. Error Handling

### Catching and Diagnosing `LoadDynamicLibraryException`

When a library cannot be found or lacks necessary OS dependencies, `loadDynamicLibrary` throws a `LoadDynamicLibraryException` containing verbose diagnostic information.

```dart
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  try {
    // Attempting to load a non-existent library
    loadDynamicLibrary(libraryName: 'does_not_exist');
  } on LoadDynamicLibraryException catch (e) {
    // The exception toString() provides the search path, desired path,
    // current directory, and OS dependency check outputs if applicable.
    print('Diagnosing failure:');
    print(e.toString());
    
    // You can also access the direct cause
    print('Cause: ${e.cause}');
  } catch (e) {
    // Fallback for other errors
    print('Unexpected error: $e');
  }
}
```

### Manually Invoking OS Dependency Checks

If you have the path to a dynamic library and want to manually diagnose missing dependencies (like `dumpbin` on Windows, `otool` on macOS, or `ldd` on Linux), use `callOSDependencyCheck`.

```dart
import 'dart:io';
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  // Example path (replace with a real library path)
  final String path = fullLibraryPath('my_faulty_lib');
  
  if (File(path).existsSync()) {
    ProcessResult result = callOSDependencyCheck(path);
    print('Dependency Check Output:');
    print('stdout: ${result.stdout}');
    print('stderr: ${result.stderr}');
  } else {
    print('File does not exist to run dependency check: $path');
  }
}
```

## 4. Advanced Usage

### Loading Raw / Versioned Dynamic Libraries

Sometimes dynamic libraries have non-standard naming conventions, such as versioned Linux shared objects (e.g., `libonnxruntime.so.1.14.1`). In this case, use `loadDynamicLibraryRaw` to bypass the platform prefix/extension assumptions.

```dart
import 'dart:ffi';
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  try {
    // Bypasses adding 'lib' prefix or '.so' extension
    final DynamicLibrary rawLib = loadDynamicLibraryRaw(
      fileName: 'libonnxruntime.so.1.14.1',
      searchPath: '/usr/local/lib',
    );
    print('Successfully loaded raw versioned library.');
  } on LoadDynamicLibraryException catch (e) {
    print('Failed to load raw library: ${e.cause}');
  }
}
```

### FRB Resolution with ByteData Cache

When shipping Flutter apps, you might bundle the compiled Rust library as a raw asset. `initializeFrbLibrary` allows you to load the library from `ByteData`, caching it to a local directory before loading.

```dart
import 'dart:io';
import 'dart:typed_data';
import 'package:dynamic_library/dynamic_library.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';

// Assume this is the generated init function from FRB
Future<void> mockRustLibInit({required ExternalLibrary externalLibrary}) async {
  print('Rust library initialized');
}

void main() async {
  // Simulating loading bytes from a Flutter Asset bundle
  // ByteData libBytes = await rootBundle.load('assets/libruntime_native_audio.so');
  ByteData mockLibBytes = ByteData(10); 
  
  // Define a temporary cache directory
  Directory cacheDir = Directory.systemTemp.createTempSync('frb_cache');
  
  try {
    await initializeFrbLibrary(
      packageName: 'runtime_native_audio',
      rustLibInit: mockRustLibInit,
      libBytes: mockLibBytes,
      libBytesCacheDir: cacheDir,
      assumeLocalResolution: false, // Must be false when providing libBytes
    );
    print('Loaded FRB library from ByteData successfully.');
  } catch (e) {
    print('Failed to load from bytes: $e');
  } finally {
    // Cleanup cache directory for the example
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }
}
```

### Utilizing Directory Resolution Helpers

For advanced path resolution, the package exposes helpers to find standard asset and library directories across different environments (like bundled macOS `.app` vs local unpackaged builds).

```dart
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  // Find the standard flutter assets directory
  String assetsDir = flutterAssetsDirectory(localDebugMode: false);
  print('Standard Flutter Assets Dir: $assetsDir');
  
  // Find the default library directory (e.g. Frameworks on macOS)
  String defaultLibDir = defaultLibraryDirectory(localDebugMode: false);
  print('Default Library Dir: $defaultLibDir');
}
```

### Custom FRB Naming Conventions

The `flutter_rust_bridge` package requires specific naming conventions on macOS (dropping the `lib` prefix). You can utilize `frbDynamicLibraryName` and `frbFullLibraryPath` to manually resolve these correctly.

```dart
import 'package:dynamic_library/dynamic_library.dart';

void main() {
  const String packageName = 'my_rust_core';
  
  // Resolves to 'my_rust_core.dylib' on macOS, 'libmy_rust_core.so' on Linux
  final String frbName = frbDynamicLibraryName(packageName);
  print('FRB formatted name: $frbName');
  
  // Resolves the full path applying the same platform-specific prefix logic
  final String frbPath = frbFullLibraryPath(packageName);
  print('FRB full path: $frbPath');
}
```
