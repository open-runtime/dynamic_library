# dynamic_library v1.1.5

> Bug fix release — 2026-04-22

## Bug Fixes

- **macOS Path Resolution** — Corrected the path resolution logic for `flutterAssetsDirectory` and `defaultLibraryDirectory` on macOS. Previously, the resolution paths differed depending on `localDebugMode`, leading to incorrect paths in bundled applications. Both functions now consistently point to the correct `Frameworks` and `flutter_assets` directories. The `localDebugMode` parameter has been retained for backwards compatibility. ([#11](https://github.com/open-runtime/dynamic_library/pull/11), [#12](https://github.com/open-runtime/dynamic_library/pull/12))

## CI & Internal

- **Autodoc Stability** — Made the release pipeline autodoc step best-effort and temporarily disabled the feature in CI pending upstream tooling fixes. ([#15](https://github.com/open-runtime/dynamic_library/pull/15), [#16](https://github.com/open-runtime/dynamic_library/pull/16))
- **Docs Freshness** — Advanced the core module hash to unblock docs-freshness checks and regenerate autodocs. ([#13](https://github.com/open-runtime/dynamic_library/pull/13))

## Install / Upgrade

**Existing consumers:**
```bash
dart pub upgrade dynamic_library
```

**New consumers — add to your `pubspec.yaml`:**
```yaml
dependencies:
  dynamic_library:
    git:
      url: git@github.com:open-runtime/dynamic_library.git
      ref: v1.1.5
```

Then run `dart pub get` to install.

> View on [GitHub](https://github.com/open-runtime/dynamic_library/releases/tag/v1.1.5)

## Contributors

Thanks to everyone who contributed to this release:
- @letterle-at-pieces
- @robert-at-pieces
## Issues Addressed

- [#14](https://github.com/open-runtime/dynamic_library/issues/14) — Bump runtime_ci_tooling pin to v0.26.1 and regenerate workflow templates (confidence: 80%)
- [#12](https://github.com/open-runtime/dynamic_library/issues/12) — Fix: defaultLibraryDirectory for MacOS should now point to the correct location (confidence: 100%)
## Full Changelog

[v1.1.4...v1.1.5](https://github.com/open-runtime/dynamic_library/compare/v1.1.4...v1.1.5)
