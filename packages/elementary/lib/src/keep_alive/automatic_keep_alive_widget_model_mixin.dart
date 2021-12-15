import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

/// A mixin with convenience methods for clients of [AutomaticKeepAlive].
/// Used with [WidgetModel] subclasses.
mixin AutomaticKeepAliveWidgetModelMixin<W extends ElementaryWidget,
    M extends ElementaryModel> on WidgetModel<W, M> {
  KeepAliveHandle? _keepAliveHandle;
  bool _wantKeepAlive = true;

  /// Setup new value of keeping alive.
  // ignore: avoid_positional_boolean_parameters
  void setupWantKeepAlive(bool value) {
    if (_wantKeepAlive != value) {
      _wantKeepAlive = value;
      _updateKeepAlive();
    }
  }

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    if (_wantKeepAlive) {
      _ensureKeepAlive();
    }
  }

  @override
  void deactivate() {
    if (_keepAliveHandle != null) {
      _releaseKeepAlive();
    }
    super.deactivate();
  }

  void _updateKeepAlive() {
    if (_wantKeepAlive) {
      if (_keepAliveHandle == null) {
        _ensureKeepAlive();
      }
    } else {
      if (_keepAliveHandle != null) {
        _releaseKeepAlive();
      }
    }
  }

  void _ensureKeepAlive() {
    assert(_keepAliveHandle == null);
    _keepAliveHandle = KeepAliveHandle();
    KeepAliveNotification(_keepAliveHandle!).dispatch(context);
  }

  void _releaseKeepAlive() {
    _keepAliveHandle!.release();
    _keepAliveHandle = null;
  }
}
