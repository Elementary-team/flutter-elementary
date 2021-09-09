import 'dart:async';

import 'package:elementary/src/model.dart';
import 'package:elementary/src/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef WidgetModelBuilder = WidgetModel Function(BuildContext context);

abstract class IWM {}

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

  @protected
  @mustCallSuper
  void onCreate() {
    _model.init();
    _errorSubscription = _model.errorTranslator.listen(onErrorHandle);
    didChangeDependencies();
  }

  @protected
  void didUpdateWidget(W oldWidget) {}

  @protected
  void didChangeDependencies() {}

  @protected
  void onErrorHandle(Object error) {}

  @protected
  @mustCallSuper
  void dispose() {
    _errorSubscription?.cancel();
    _model.dispose();
  }
}

class WMElement extends ComponentElement {
  @override
  WMWidget get widget => super.widget as WMWidget;

  late WidgetModel _wm;

  // хак из-за закрытого _firstBuild
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
    // хак из-за закрытого _firstBuild
    if (!_isInitialized) {
      _wm = widget.wmBuilder(this);
      _wm
        .._element = this
        .._widget = widget
        ..onCreate();

      _isInitialized = true;
    }

    super.performRebuild();
  }
}
