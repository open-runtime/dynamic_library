# dynamic_library v1.1.1

- **Decision**: patch
- **Key Changes**:
  - Regenerated CI/CD templates (`.github/workflows`) from `runtime_ci_tooling` v0.23.10.
  - Enabled the `autodoc` tool and artifact workflow generation in `.runtime_ci/config.json`.
  - Upgraded Dart workspace resolution and dev dependency `runtime_ci_tooling` to `^0.23.0` in `pubspec.yaml`.
  - Added new `.gemini/policies/autodoc-safety.toml` policy file and updated `.gemini/settings.json`.
  - Standardized Dart formatting across multiple files using `dart format --line-length 120`.
- **Breaking Changes**: None
- **New Features**: None
- **References**:
  - `chore(ci): regenerate workflows from runtime_ci_tooling v0.23.10`
  - `bot(format): apply dart format --line-length 120`
  - `chore(pub): align Dart workspace resolution and dependency constraints`
  - `chore(ci): enable autodoc + regenerate workflows from v0.23.7`


## Changelog

## [1.1.1] - 2026-03-24

### Added
- Added autodoc safety policy to restrict docs-only runs to markdown outputs

### Changed
- Regenerated and upgraded CI/CD workflows from runtime_ci_tooling v0.23.7 to v0.23.10, including node 24 overrides, autodoc artifact flow fixes, and renaming prepare-release-docs
- Aligned Dart workspace resolution and dependency constraints
- Applied dart format --line-length 120 across the codebase

---
[Full Changelog](https://github.com/open-runtime/dynamic_library/compare/v1.1.0...v1.1.1)
