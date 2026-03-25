## [1.1.2] - 2026-03-25

### Added
- Added `read_file`, `read_many_files`, `write_file`, `replace`, `glob`, `grep_search`, `list_directory` to `settings.json` `tools.core`
- Configured autodoc CI to use `gemini-3-flash-preview` for doc reviews

### Changed
- Updated `autodoc-safety.toml` policy and regenerated workflow templates
- Regenerated CI workflows with auto-autodoc Gemini regeneration enabled
- Bumped `setup-dart` to v1.7.2 and regenerated from latest templates
- Regenerated CI workflows from `runtime_ci_tooling` v0.23.10