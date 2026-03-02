## [1.1.0] - 2026-03-02

### Added
- Added `flutterAssetsDirectory` and `defaultLibraryDirectory` functions to assist in dependency resolution for different platforms (#9)
- Added optional `includePrefix` argument to `fullLibraryName` and `fullLibraryPath` functions to toggle lib prefix for backward compatibility (#9)

### Changed
- Bumped `flutter_rust_bridge` dependency to `^2.11.1` (#9)

### Fixed
- Resolved circular import and updated out-of-date function comments (#9)