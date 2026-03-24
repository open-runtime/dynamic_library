## [1.1.1] - 2026-03-24

### Added
- Added autodoc safety policy to restrict docs-only runs to markdown outputs

### Changed
- Regenerated and upgraded CI/CD workflows from runtime_ci_tooling v0.23.7 to v0.23.10, including node 24 overrides, autodoc artifact flow fixes, and renaming prepare-release-docs
- Aligned Dart workspace resolution and dependency constraints
- Applied dart format --line-length 120 across the codebase