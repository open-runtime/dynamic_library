# dynamic_library

[![pub package][pub_badge]][pub_badge_link]
[![License: MIT][license_badge]][license_badge_link]
[![style: runtime_lints][style_badge]][style_badge_link]

> **_NOTE:_**  This package is currently released under `0.*.*` version semantics and should not
> be considered to have a stable API until version `1.*.*`

This Dart package is focused on providing better experiences related to `DynamicLibrary` usage in 
Dart and Flutter projects. This package is used internally at [Pieces.app][pieces_link] and [Runtime.dev][runtime_link]

We considered using the [dylib](https://pub.dev/packages/dylib) package but found it insufficient to provide
descriptive errors when working with dynamic libraries on Dart and Flutter Applications. Dynamic libraries could
fail to load for any one of the following reasons:

* The file doesn't exist
* The directory doesn't exist that we are searching in
* The dynamic library is missing dependencies

The implementation of `DynamicLibrary` in the dart standard library fails to say essentially anything other 
than 'DynamicLibrary fails to load'. When deploying multiple dynamic libraries across multiple platforms, we really need
traceability to know if the dynamic library doesn't exist, isn't in the right place or is missing dependencies to
better inform the developer on proper debugging steps or work scope estimation.

## Project Layout

This package follows the traditional dart package layout:

* `example` - example usage
* `lib` - source code
* `test` - tests

This project also has more source code is are used to verify the unique requirements of 
dynamic libraries for Flutter applications + Dart applications. These tests are currently not
in CI/CD and are checked manually for releases, but this will be resolved in the future.

* `flutter_example/` - flutter application to use to test out dynamic library loading
  in a bundled application
* `rust_*/` - the rust folders are used to build dynamic libraries for testing

## Usage

TODO: Include snippets and examples

Note: It is recommended to not use `searchPaths` when using this library in compiled applications as there are a 
lot of cross-platform variables to consider in your application. This `searchPaths` parameter is more useful for
running dart code in a development environment (with binaries in various locations), instead of in production 
environments.


## Contributing

This package is [maintained on Github][repo_link]

[analysis_options_yaml]: https://github.com/open-runtime/dynamic_library/blob/main/analysis_options.yaml
[ci_badge]: https://github.com/open-runtime/dynamic_library/workflows/ci/badge.svg
[ci_badge_link]: https://github.com/open-runtime/dynamic_library/actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_badge_link]: https://opensource.org/licenses/MIT
[ci_badge_link]: https://github.com/open-runtime/dynamic_library/actions
[pub_badge]: https://img.shields.io/pub/v/dynamic_library.svg
[pub_badge_link]: https://pub.dev/packages/dynamic_library

[style_badge]: https://img.shields.io/badge/style-dynamic_library-B22C89.svg
[style_badge_link]: https://pub.dev/packages/runtime_lints

[open_runtime_github]: https://github.com/open-runtime
[repo_link]: https://github.com/open-runtime/dynamic_library
[runtime_link]: https://runtime.dev
[pieces_link]: https://code.pieces.app
