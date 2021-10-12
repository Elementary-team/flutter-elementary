import 'package:elementary/elementary.dart';
import 'package:elementary/src/core.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _TestWmWidget wmWidget;

  setUp(() {
    wmWidget = const _TestWmWidget(_testWmFactory);
  });

  test('WmWidget should create correct type element', () {
    final result = wmWidget.createElement();

    expect(result, const TypeMatcher<WMElement>());
  });
}

_TestWidgetModel _testWmFactory(BuildContext context) {
  return _TestWidgetModel(_TestModel());
}

class _TestWmWidget extends WMWidget {
  const _TestWmWidget(WidgetModelFactory wmFactory) : super(wmFactory);

  @override
  Widget build(IWM wm) {
    throw UnimplementedError();
  }
}

class _TestWidgetModel extends WidgetModel<_TestWmWidget, _TestModel> {
  _TestWidgetModel(_TestModel model) : super(model);
}

class _TestModel extends Model {}
