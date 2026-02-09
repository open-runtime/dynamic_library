## 1.0.0

- **Breaking**: Bumped minimum Dart SDK to `>=3.6.0 <4.0.0`
- Added `frb_init.dart` module with Flutter Rust Bridge initialization utilities:
  - `frbDynamicLibraryName()` -- builds platform-correct FRB library filenames (handles macOS no-prefix convention)
  - `frbFullLibraryPath()` -- resolves full path with macOS prefix-strip workaround
  - `initializeFrbLibrary()` -- high-level init function replacing ~95 lines of duplicated init logic across FRB packages
- Added `flutter_rust_bridge` as a dependency (for `ExternalLibrary` type)

## 0.9.0

- Added `flutter_example` application for testing dynamic library resolution in compiled applications
- Added minimal Rust libraries `rust_foo` + `rust_hello_world` for building dynamic libraries to test with
- Fixed the dynamic_library loading scheme by deferring the `File().exists()` -- which fails on flutter applications -- 
  check until failure to enrich exceptions.

## 0.8.0

- Fixed cases where loading libraries will fail on MacOS with relative paths on hardened runtimes by
  always using full paths when 
- Surfaced `isDart()` function in `loader.dart` to enable Dart JIT runtime environments

## 0.7.0

- Widened Dart SDK requirement to '>=2.12.0 <3.0.0'

## 0.6.0

- Added unit tests
- CI/CD runs tests on 3 platforms on "Test" workflow
- Minor formatting change in exception print-out

## 0.5.0

- Fixed "Resolved Full Path" to use Library Path instead of name
- Minor changes to the positioning of '\t' in exception strings (moved to beginning instead of end of line)

## 0.4.0

- Replaced `libraryFile` with `libraryPath` to run OS Dependency check on the proper files
- More expressive exception when dynamic library fails to load (throws message from `DynamicLibrary.open()` instead of
  obscuring it)

## 0.3.0

Breaking changes:
- Return type for `loadDynamicLibrary()` is no longer nullable (function should throw an error if loading fails)

## 0.2.0

Changes:
- Improved README and examples
- Fixed wrong OS order in `callOSDependencyCheck()`

Breaking Changes: 
- `loadDynamicLibrary()` and `callOSDependencyCheck()` updated to be synchronous

## 0.1.0

- Initial version.
