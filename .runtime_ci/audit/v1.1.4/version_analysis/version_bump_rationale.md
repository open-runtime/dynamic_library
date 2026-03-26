# Version Bump Rationale

**Decision**: patch

This release addresses a maintenance task, specifically the removal of the `runtime_ci_tooling` package from `dev_dependencies` in `pubspec.yaml`. This package is now globally activated in CI pipelines, and having it as a git dependency caused workspace resolution conflicts when the package is also a workspace member in the monorepo. This does not affect the functionality or public API of the package.

**Key Changes**:
* Removed `runtime_ci_tooling` from `dev_dependencies` to resolve monorepo workspace conflicts.

**Breaking Changes**:
* None. The change is restricted to development workflow metadata and internal tooling dependencies.

**New Features**:
* None.

**References**:
* Merge pull request #10 from open-runtime/chore/productionize-agentic-systems
* Commit: `chore: remove runtime_ci_tooling dev_dependency`
