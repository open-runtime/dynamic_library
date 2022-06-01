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
