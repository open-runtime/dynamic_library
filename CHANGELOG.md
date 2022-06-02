## 0.7.0

- Widened Dart SDK requirement to '>=2.12.0 <3.0.0'

## 0.6.0

- Added unit tests
- CI/CD runs tests on 3 platforms on "Test" workflow
- Minor formatting change in exception print-out

## 0.5.0

- Fixed "Resolved Full Path" to use Library Path instead of name
- Minor changes to the positioning of '\t' in exception strings (moved to beginning instead of end of line)

## 0.4.0

- Replaced `libraryFile` with `libraryPath` to run OS Dependency check on the proper files
- More expressive exception when dynamic library fails to load (throws message from `DynamicLibrary.open()` instead of
  obscuring it)

## 0.3.0

Breaking changes:
- Return type for `loadDynamicLibrary()` is no longer nullable (function should throw an error if loading fails)

## 0.2.0

Changes:
- Improved README and examples
- Fixed wrong OS order in `callOSDependencyCheck()`

Breaking Changes: 
- `loadDynamicLibrary()` and `callOSDependencyCheck()` updated to be synchronous

## 0.1.0

- Initial version.
