# dynamic_library v1.1.4

> Maintenance release — 2026-03-26

## Maintenance & Chores

- **Resolved workspace conflicts** — Removed the `runtime_ci_tooling` development dependency from `pubspec.yaml` as it is globally activated in CI pipelines, resolving workspace resolution conflicts when the package is also a workspace member. ([#10](https://github.com/open-runtime/dynamic_library/pull/10))

## Issues Addressed

No linked issues for this release.
## Contributors

Thanks to everyone who contributed to this release:
- @tsavo-at-pieces
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

> View on [GitHub](https://github.com/open-runtime/dynamic_library/releases/tag/v1.1.4)

## Full Changelog

[v1.1.3...v1.1.4](https://github.com/open-runtime/dynamic_library/compare/v1.1.3...v1.1.4)