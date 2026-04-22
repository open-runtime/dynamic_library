# Version Bump Rationale

**Decision**: patch

**Rationale**:
The updates in this release consist of bug fixes and CI/chore modifications. The primary code change fixes a bug in macOS path resolution within `frb_init.dart`. Although the internal handling of the `localDebugMode` parameter changed on macOS, the parameter itself was preserved in the public API signature to maintain backwards compatibility, avoiding a breaking change. The rest of the commits focus on tweaking CI configuration (making `autodoc` best-effort and temporarily disabling it) and advancing hashes to unblock freshness checks. None of these changes introduce new features or break public APIs.

**Key Changes**:
- **Fix**: Corrected the macOS path resolution for `flutterAssetsDirectory` and `defaultLibraryDirectory`. The `localDebugMode` parameter is now unused on macOS but was retained for backwards compatibility.
- **Chore/CI**: Made the `autodoc` release pipeline step best-effort.
- **Chore/CI**: Temporarily disabled `autodoc` in `.runtime_ci/config.json` pending tooling fixes.
- **Chore**: Advanced the core module hash to unblock `docs-freshness` checks.

**Breaking Changes**:
- None.

**New Features**:
- None.

**References**:
- PR #12: Fix: defaultLibraryDirectory for MacOS should now point to the correct location
- PR #13: chore(autodoc): advance core module hash to unblock docs-freshness
- PR #15: chore(ci): disable autodoc until tooling fixes land
- PR #16: chore(ci): make release-pipeline autodoc step best-effort