# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2026-03-02

### Added
- Initialized runtime_ci_tooling scaffolding for the repository, including CI, issue triage, and release workflows (#8)
- Added autodoc configuration and prompt generators for automated documentation generation (#8)
- Added Gemini CLI commands and settings for repository management (#8)

### Changed
- Aligned runtime CI runner overrides in the config to drive runner and token behavior from configuration
- Applied dart format to library files with line-length 120 (#8)

### Fixed
- Unblocked queued x64 jobs on hosted runners by routing ubuntu-x64 and windows-x64 matrix entries to GitHub-hosted runner labels (#8)
- Addressed high-priority workflow review findings, corrected token fallback expressions, and guarded Gemini CLI installation (#8)

### Security
- Added explicit least-privilege permissions to CI workflows to improve security (#8)

## 1.0.2

- Refactored shared loader logic: extracted `_resolveLibraryPath` and `_openWithDiagnostics` to deduplicate `loadDynamicLibrary` and `loadDynamicLibraryRaw`
- Added test coverage for `loadDynamicLibraryRaw` exception paths

## 1.0.1

- Added `loadDynamicLibraryRaw()` for loading libraries with non-standard filenames (e.g., versioned Linux shared objects like `libonnxruntime.so.1.23.2`)
- Updated dependencies: unified workspace dependencies and bumped `flutter_lints` to `^6.0.0`
- Bumped minimum Dart SDK to `>=3.9.0`

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

[1.0.3]: https://github.com/open-runtime/dynamic_library/releases/tag/v1.0.3
