# dynamic_library v1.0.3

# Version Bump Rationale

- **Decision**: patch (Internal tooling and CI changes)
- **Key Changes**:
  - Initialized `runtime_ci_tooling` and set up generated CI/release/triage workflows (`.github/workflows/`, `.runtime_ci/config.json`).
  - Added repository-local autodoc configuration and prompts to automate documentation updates (`scripts/prompts/`, `.runtime_ci/autodoc.json`).
  - Set CI PAT secret name and added x64 runner overrides in `.runtime_ci/config.json`.
  - Routed ubuntu-x64 and windows-x64 matrix entries to GitHub-hosted runner labels.
  - Added explicit least-privilege permissions to CI workflows and fixed token fallback expressions.
  - Applied `dart format --line-length 120` to `lib/src/frb_init.dart` and `lib/src/loader.dart`.
  - Configured repository-specific Gemini CLI commands for changelog generation and issue triaging (`.gemini/`).
  - Added `runtime_ci_tooling` to `dev_dependencies` in `pubspec.yaml`.
- **Breaking Changes**: None
- **New Features**: None
- **References**:
  - PR #8 (open-runtime/chore/runtime-ci-tooling-setup)
  - `chore(ci): align runtime CI runner overrides in config`
  - `fix(ci): unblock queued x64 jobs on hosted runners`
  - `fix(ci): address high-priority workflow review findings`
  - `bot(format): apply dart format --line-length 120 [skip ci]`


---
[Full Changelog](https://github.com/open-runtime/dynamic_library/compare/v1.0.2...v1.0.3)
