# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.3] - 2026-03-25

### Changed
- Updated timestamps in `template_versions.json` and removed an empty line in `pubspec.yaml` for cleaner formatting

## [1.1.2] - 2026-03-25

### Added
- Added `read_file`, `read_many_files`, `write_file`, `replace`, `glob`, `grep_search`, `list_directory` to `settings.json` `tools.core`
- Configured autodoc CI to use `gemini-3-flash-preview` for doc reviews

### Changed
- Updated `autodoc-safety.toml` policy and regenerated workflow templates
- Regenerated CI workflows with auto-autodoc Gemini regeneration enabled
- Bumped `setup-dart` to v1.7.2 and regenerated from latest templates
- Regenerated CI workflows from `runtime_ci_tooling` v0.23.10

## [1.1.1] - 2026-03-24

### Added
- Added autodoc safety policy to restrict docs-only runs to markdown outputs

### Changed
- Regenerated and upgraded CI/CD workflows from runtime_ci_tooling v0.23.7 to v0.23.10, including node 24 overrides, autodoc artifact flow fixes, and renaming prepare-release-docs
- Aligned Dart workspace resolution and dependency constraints
- Applied dart format --line-length 120 across the codebase

## [1.1.0] - 2026-03-02

### Added
- Added `flutterAssetsDirectory` and `defaultLibraryDirectory` functions to assist in dependency resolution for different platforms (#9)
- Added optional `includePrefix` argument to `fullLibraryName` and `fullLibraryPath` functions to toggle lib prefix for backward compatibility (#9)

### Changed
- Bumped `flutter_rust_bridge` dependency to `^2.11.1` (#9)

### Fixed
- Resolved circular import and updated out-of-date function comments (#9)

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
- Fixed the dynamic_library loading scheme by deferring the `File().exists()` -- which fails on Flutter applications -- 
  check until failure to enrich exceptions.

## 0.8.0

- Fixed cases where loading libraries will fail on macOS with relative paths on hardened runtimes by
  always using full paths.
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

[1.1.3]: https://github.com/open-runtime/dynamic_library/compare/v1.1.2...v1.1.3
[1.1.2]: https://github.com/open-runtime/dynamic_library/compare/v1.1.1...v1.1.2
[1.1.1]: https://github.com/open-runtime/dynamic_library/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/open-runtime/dynamic_library/compare/v1.0.3...v1.1.0
[1.0.3]: https://github.com/open-runtime/dynamic_library/releases/tag/v1.0.3
