# dynamic_library v1.1.3

> Maintenance release — 2026-03-25

## Changes

- **Formatting & Configuration** — Removed an empty line in `pubspec.yaml` for cleaner formatting and updated timestamps in `.runtime_ci/template_versions.json` to reflect the latest template updates.

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
      tag_pattern: v{{version}}
```

Then run `dart pub get` to install.

> View on [GitHub](https://github.com/open-runtime/dynamic_library/releases/tag/v1.1.3)

## Issues Addressed

No linked issues for this release.
## Contributors

Thanks to everyone who contributed to this release:
- @tsavo-at-pieces
## Full Changelog

[v1.1.2...v1.1.3](https://github.com/open-runtime/dynamic_library/compare/v1.1.2...v1.1.3)
