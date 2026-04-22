## [1.1.5] - 2026-04-22

### Changed
- Updated core module hash to unblock docs-freshness and regenerate autodocs (#13)
- Disabled autodoc in CI temporarily until tooling fixes land (#15)
- Made release-pipeline autodoc step best-effort to prevent failures (#16)

### Fixed
- Fixed flutter assets resolution path for macOS (#11)
- Fixed `defaultLibraryDirectory` for MacOS to point to the correct location (#12) (fixes #12)