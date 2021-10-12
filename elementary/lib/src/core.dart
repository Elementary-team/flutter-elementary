import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Factory function for creating Widget Model.
typedef WidgetModelFactory<T extends WidgetModel> = T Function(
  BuildContext context,
);

/// Base interface for all Widget Model.
abstract class IWM {}

/// A widget that use WidgetModel for build.
///
/// You must provide [wmFactory] factory function to the constructor
/// to instantiate WidgetModel. For testing, you can replace
/// this function for returning mock.
abstract class WMWidget<I extends IWM> extends Widget {
  final WidgetModelFactory wmFactory;

  const WMWidget(
    this.wmFactory, {
    Key? key,
  }) : super(key: key);

  /// Creates a [WMElement] to manage this widget's location in the tree.
  ///
  /// It is uncommon for subclasses to override this method.
  @override
  Element createElement() {
    return WMElement(this);
  }

  /// Describes the part of the user interface represented by this widget.
  ///
  /// You can use all properties and methods provided by Widget Model.
  /// You should not use [BuildContext] or something else, all you need
  /// must contains in Widget Model.
  Widget build(I wm);
}

/// Class that contains all presentation logic of the widget.
abstract class WidgetModel<W extends WMWidget, M extends Model>
    with Diagnosticable
    implements IWM {
  final M _model;

  @protected
  M get model => _model;

  @protected
  @visibleForTesting
  W get widget => _widget!;

  BuildContext get context {
    assert(() {
      if (_element == null) {
        throw FlutterError('This widget has been unmounted');
      }
      return true;
    }());
    return _element!;
  }

  WMElement? _element;
  W? _widget;

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
  void onErrorHandle(Object error) {}

  /// Called when element with this Widget Model is removed from the tree
  /// permanently.
  @protected
  @mustCallSuper
  @visibleForTesting
  void dispose() {
    _model.dispose();
  }

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupTestWidget(W? testWidget) {
    _widget = testWidget;
  }

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupTestElement(WMElement? testElement) {
    _element = testElement;
  }
}

/// An element for managing a widget whose display depends on the Widget Model.
class WMElement extends ComponentElement {
  @override
  WMWidget get widget => super.widget as WMWidget;

  late WidgetModel _wm;

  // private _firstBuild hack
  bool _isInitialized = false;

  WMElement(WMWidget widget) : super(widget);

  @override
  Widget build() => widget.build(_wm);

  @override
  void update(WMWidget newWidget) {
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
abstract class Model {
  final ErrorHandler? _errorHandler;
  void Function(Object)? _wmHandler;

  Model({ErrorHandler? errorHandler}) : _errorHandler = errorHandler;

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

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupWmHandler(Function(Object)? function) {
    _wmHandler = function;
  }
}
