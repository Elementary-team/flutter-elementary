import 'dart:async';

import 'package:elementary/src/model.dart';
import 'package:elementary/src/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Factory function for creating Widget Model.
typedef WidgetModelFactory<T extends WidgetModel> = WidgetModel Function(
  BuildContext context,
);

/// Base interface for all Widget Model.
abstract class IWM {}

/// Class that contains all presentation logic of the widget.
abstract class WidgetModel<W extends WMWidget, M extends Model>
    with Diagnosticable
    implements IWM {
  final M _model;

  @protected
  M get model => _model;

  @protected
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
  StreamSubscription<Object>? _errorSubscription;

  WidgetModel(this._model);

  /// Called at first build for initialization of this Widget Model.
  @protected
  @mustCallSuper
  void initWidgetModel() {
    _model.init();
    _errorSubscription = _model.errorTranslator.listen(onErrorHandle);
  }

  /// Called whenever the widget configuration changes.
  @protected
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
  void dispose() {
    _errorSubscription?.cancel();
    _model.dispose();
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
