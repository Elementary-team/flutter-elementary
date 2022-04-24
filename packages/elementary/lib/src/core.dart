import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Factory function for creating Widget Model.
typedef WidgetModelFactory<T extends WidgetModel> = T Function(
  BuildContext context,
);

/// Base interface for all Widget Model.
abstract class IWidgetModel {}

/// A widget that use WidgetModel for build.
///
/// You must provide [wmFactory] factory function to the constructor
/// to instantiate WidgetModel. For testing, you can replace
/// this function for returning mock.
abstract class ElementaryWidget<I extends IWidgetModel> extends Widget {
  /// Factory-function for creating WidgetModel
  final WidgetModelFactory wmFactory;

  /// Create an instance of ElementaryWidget.
  const ElementaryWidget(
    this.wmFactory, {
    Key? key,
  }) : super(key: key);

  /// Creates a [Elementary] to manage this widget's location
  /// in the tree.
  ///
  /// It is uncommon for subclasses to override this method.
  @override
  Element createElement() {
    return Elementary(this);
  }

  /// Describes the part of the user interface represented by this widget.
  ///
  /// You can use all properties and methods provided by Widget Model.
  /// You should not use [BuildContext] or something else, all you need
  /// must contains in Widget Model.
  Widget build(I wm);
}

/// Entity that contains all presentation logic of the widget.
abstract class WidgetModel<W extends ElementaryWidget,
    M extends ElementaryModel> with Diagnosticable implements IWidgetModel {
  final M _model;

  /// [ElementaryModel] for this WidgetModel.
  /// Only one of business-logic dependencies, that WidgetModel needs.
  @protected
  @visibleForTesting
  M get model => _model;

  /// Widget that use WidgetModel for build.
  @protected
  @visibleForTesting
  W get widget => _widget!;

  /// A handle to the location of a WidgetModel in the tree.
  @protected
  @visibleForTesting
  BuildContext get context {
    assert(() {
      if (_element == null) {
        throw FlutterError('This widget has been unmounted');
      }
      return true;
    }());
    return _element!;
  }

  /// Are this [WidgetModel] and [Elementary] currently mounted in a tree.
  @protected
  @visibleForTesting
  bool get isMounted => _element != null;

  Elementary? _element;
  W? _widget;

  /// Create an instance of WidgetModel.
  WidgetModel(this._model);

  /// Called at first build for initialization of this Widget Model.
  @protected
  @mustCallSuper
  @visibleForTesting
  void initWidgetModel() {
    _model
      ..init()
      .._wmHandler = onErrorHandle;
  }

  /// Called whenever the widget configuration changes.
  @protected
  @visibleForTesting
  void didUpdateWidget(W oldWidget) {}

  /// Called when a dependency of this Widget Model changes.
  ///
  /// For example, if Widget Model has reference an
  /// [InheritedWidget] that later changed, this
  /// method will called to notify about change.
  ///
  /// This method is also called immediately after [initWidgetModel].
  /// It is safe to call [BuildContext.dependOnInheritedWidgetOfExactType]
  /// from this method.
  @protected
  @visibleForTesting
  void didChangeDependencies() {}

  /// Called whenever the Model use method handleError.
  ///
  /// This method is the place for presentation handling error like a
  /// showing snackbar or something else.
  @protected
  @visibleForTesting
  void onErrorHandle(Object error) {}

  /// Called when this WidgetModel and Elementary are removed from the tree.
  ///
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.deactivate()`.
  @protected
  @mustCallSuper
  @visibleForTesting
  void deactivate() {}

  /// Called when this WidgetModel and Elementary are reinserted into the tree
  /// after having been removed via [deactivate].
  ///
  /// In most cases, after a WidgetModel has been deactivated, it is not
  /// reinserted into the tree, and its [dispose] method will be called to
  /// signal that it is ready to be garbage collected.
  ///
  /// In some cases, however, after a WidgetModel has been deactivated, it will
  /// reinserted it into another part of the tree (e.g., if the
  /// subtree containing this Elementary of this WidgetModel is grafted from
  /// one location in the tree to another due to the use of a [GlobalKey]).
  ///
  /// This method does not called the first time a WidgetModel object
  /// is inserted into the tree. Instead, calls [initWidgetModel] in
  /// that situation.
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.activate()`.
  @protected
  @mustCallSuper
  @visibleForTesting
  void activate() {}

  /// Called when element with this Widget Model is removed from the tree
  /// permanently.
  @protected
  @mustCallSuper
  @visibleForTesting
  void dispose() {
    _model.dispose();
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload. Most cases therefore do not need to do
  /// anything in the [reassemble] method.
  ///
  /// See also:
  ///  * [Element.reassemble]
  ///  * [BindingBase.reassembleApplication]
  @protected
  @mustCallSuper
  @visibleForTesting
  void reassemble() {}

  /// Method for setup WidgetModel for testing.
  /// This method can be used to set widget.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupTestWidget(W? testWidget) {
    _widget = testWidget;
  }

  /// Method for setup WidgetModel for testing.
  /// This method can be used to set element (BuildContext).
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupTestElement(Elementary? testElement) {
    _element = testElement;
  }
}

/// An element for managing a widget whose display depends on the Widget Model.
class Elementary extends ComponentElement {
  @override
  ElementaryWidget get widget => super.widget as ElementaryWidget;

  late WidgetModel _wm;

  // private _firstBuild hack
  bool _isInitialized = false;

  /// Create an instance of Elementary.
  Elementary(ElementaryWidget widget) : super(widget);

  @override
  Widget build() {
    return widget.build(_wm);
  }

  @override
  void update(ElementaryWidget newWidget) {
    super.update(newWidget);

    final oldWidget = _wm.widget;
    _wm
      .._widget = newWidget
      ..didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _wm.didChangeDependencies();
  }

  @override
  void activate() {
    super.activate();
    _wm.activate();

    markNeedsBuild();
  }

  @override
  void deactivate() {
    _wm.deactivate();
    super.deactivate();
  }

  @override
  void unmount() {
    super.unmount();

    _wm
      ..dispose()
      .._element = null
      .._widget = null;
  }

  @override
  void performRebuild() {
    // private _firstBuild hack
    if (!_isInitialized) {
      _wm = widget.wmFactory(this);
      _wm
        .._element = this
        .._widget = widget
        ..initWidgetModel()
        ..didChangeDependencies();

      _isInitialized = true;
    }

    super.performRebuild();
  }

  @override
  void reassemble() {
    super.reassemble();

    _wm.reassemble();
  }
}

/// Class that contains a business logic for Widget.
///
/// You can write this freestyle. It may be collection of methods,
/// streams or something else.
///
/// This class can take [ErrorHandler] for handling caught error
/// like a logging or something else. This realize by using
/// [handleError] method. This method also notifies the Widget Model about the
/// error that has occurred. You can use onErrorHandle method of Widget Model
/// to handle on UI like show snackbar or something else.
abstract class ElementaryModel {
  final ErrorHandler? _errorHandler;
  void Function(Object)? _wmHandler;

  /// Create an instance of ElementaryModel.
  ElementaryModel({ErrorHandler? errorHandler}) : _errorHandler = errorHandler;

  /// Should be used for report error Error Handler if it was set and notify
  /// Widget Model about error.
  @protected
  @mustCallSuper
  @visibleForTesting
  void handleError(Object error) {
    _errorHandler?.handleError(error);
    _wmHandler?.call(error);
  }

  /// Method for initialize this Model.
  ///
  /// Will be call at first build when Widget Model created.
  void init() {}

  /// Called when Widget Model disposing.
  void dispose() {}

  /// Method for setup ElementaryModel for testing.
  /// This method can be used to WidgetModels error handler.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupWmHandler(Function(Object)? function) {
    _wmHandler = function;
  }
}
