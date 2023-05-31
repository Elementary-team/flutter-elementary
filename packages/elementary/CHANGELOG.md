# Changelog

## Unreleased
### Added
* Alias for EntityStateNotifier's interface

## 3.0.0-dev
### Added
* [BREAKING CHANGE] support dart 3 version:
  - IWidgetModel now is abstract interface;
  - ErrorHandler now is abstract interface;
  - EntityState has become sealed;
* More detailed dartdoc for classes and methods.

### Changed
* [BREAKING CHANGE] EntityStateNotifier now extends ValueNotifier;

## 2.0.0
### Added
* [BREAKING CHANGE] supported breaking changes for noSuchMethod in dart 2.19;
    
  Migration: use MockElementaryModelMixin and MockWidgetModelMixin in the tests for WM and Model mocks to avoid fails

## 1.6.0
### Added
* builders for using ValueListenable as sources;

## 1.5.0
### Added
* widget model and model properties for elementary widget in devtool;

## 1.4.0
### Added
* possible sending stacktrace to ErrorHandler;

## 1.3.1
### Changed
* dev dependencies updated;

## 1.3.0
### Added
* property 'isMounted' for checking mounting into the tree;

## 1.2.0
### Added
* support reassemble for widget model when app hot reloaded;

## 1.1.0

* Added multi-sources builders.

## 1.0.0

* First stable release
* Remove useless prebuild hook.
* Add tests for keep alive mixin and ticker provider mixin.

## 0.1.3

* Add constraints to ticker mixins and keep alive mixin.

## 0.1.2

* Mixin for keep alive widget model.

## 0.1.1

* Add theme wrapper.

## 0.1.0-dev.1

* Update naming from dev to release ready.
* Mark protected context in widget model.

## 0.0.3-dev.5

* Model behaviour tested.
* Widget behaviour tested.

## 0.0.3-dev.4

* Infrastructure for testing all layers.

## 0.0.3-dev.3

* Add base documentation.
* Rename WidgetModelBuilder to WidgetModelFactory.
* Rename onCreate method of WidgetModel to initWidgetModel.

## 0.0.3-dev.2

* Remove required error handler for model;
* Remove doWithHandle methods, use try/catch instead.

## 0.0.3-dev.1

* Add error handling;

## 0.0.2

* Example added;

## 0.0.1

* Initial release;
