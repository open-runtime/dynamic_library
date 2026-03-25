# dynamic_library v1.1.2

# Version Bump Rationale

**Decision**: patch

**Why**: All changes in this release are related to CI and internal repository configuration updates. There are no changes to the public API, no new features, and no bug fixes in the library code itself.

**Key Changes**:
*   Updated Gemini templates from runtime_ci_tooling v0.23.10, adding new tools to `.gemini/settings.json`.
*   Regenerated workflows and bumped setup-dart to v1.7.2.
*   Updated `.runtime_ci` configuration to use gemini-3-flash-preview for doc reviews.

**Breaking Changes**:
*   None

**New Features**:
*   None

**References**:
*   chore(ci): update gemini templates from runtime_ci_tooling v0.23.10
*   chore(ci): regenerate CI with auto-autodoc Gemini regeneration
*   chore(ci): bump setup-dart v1.7.2 + regenerate from latest templates
*   chore(ci): regenerate workflows from runtime_ci_tooling v0.23.10
*   chore(autodoc): use gemini-3-flash-preview for doc reviews

## Changelog

## [1.1.2] - 2026-03-25

### Added
- Added `read_file`, `read_many_files`, `write_file`, `replace`, `glob`, `grep_search`, `list_directory` to `settings.json` `tools.core`
- Configured autodoc CI to use `gemini-3-flash-preview` for doc reviews

### Changed
- Updated `autodoc-safety.toml` policy and regenerated workflow templates
- Regenerated CI workflows with auto-autodoc Gemini regeneration enabled
- Bumped `setup-dart` to v1.7.2 and regenerated from latest templates
- Regenerated CI workflows from `runtime_ci_tooling` v0.23.10

---
[Full Changelog](https://github.com/open-runtime/dynamic_library/compare/v1.1.1...v1.1.2)
