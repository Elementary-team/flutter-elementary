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
  WMElement? _element;
  W? _widget;

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

  WidgetModel(this._model);

  @protected
  @mustCallSuper
  void onCreate() {
    _model.init();
    didChangeDependencies();
  }

  @protected
  void didUpdateWidget(W oldWidget) {}

  @protected
  void didChangeDependencies() {}

  @protected
  @mustCallSuper
  void dispose() {
    _model.dispose();
  }
}

class WMElement extends ComponentElement {
  late WidgetModel _wm;

  // хак из-за закрытого _firstBuild
  bool _isInitialized = false;

  @override
  WMWidget get widget => super.widget as WMWidget;

  WMElement(WMWidget widget) : super(widget);

  @override
  Widget build() => widget.build(_wm);

  @override
  void update(WMWidget newWidget) {
    super.update(newWidget);

    var oldWidget = _wm.widget;
    _wm._widget = newWidget;
    _wm.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _wm.didChangeDependencies();
  }

  @override
  void unmount() {
    super.unmount();

    _wm.dispose();
    _wm._element = null;
  }

  @override
  void performRebuild() {
    // хак из-за закрытого _firstBuild
    if (!_isInitialized) {
      _wm = widget.wmBuilder(this);
      _wm._element = this;
      _wm._widget = widget;
      _wm.onCreate();

      _isInitialized = true;
    }

    super.performRebuild();
  }
}
