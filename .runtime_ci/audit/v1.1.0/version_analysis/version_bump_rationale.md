**Decision**: minor

**Key Changes**:
- Added `flutterAssetsDirectory` function to help resolve asset locations dynamically based on the platform.
- Added `defaultLibraryDirectory` function to provide the default dynamic library directory based on the platform.
- Added an optional `includePrefix` named parameter to `fullLibraryName` and `fullLibraryPath` (defaults to `true` for backwards compatibility).
- Updated the `flutter_rust_bridge` dependency from `^2.9.0` to `^2.11.1`.
- Improved implementation of `frbDynamicLibraryName` and `frbFullLibraryPath` to correctly utilize `fullLibraryName` and `fullLibraryPath` under the hood.

**Breaking Changes**:
- None.

**New Features**:
- Introduced `flutterAssetsDirectory` and `defaultLibraryDirectory` utility functions for path resolution.
- Added `includePrefix` parameter for library name and path resolution.

**References**:
- PR #9: feat/dep_resolution_enhancement
- Commit: Downgrade version from 1.1.0 to 1.0.9
- Commit: Merge pull request #9
- Commit: Fix: resolved PR feedback
