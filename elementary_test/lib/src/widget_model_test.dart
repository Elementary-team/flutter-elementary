// ignore_for_file: avoid_implementing_value_types, implementation_imports, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:elementary/src/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';

@isTest
void testWidgetModel<WM extends WidgetModel, W extends WMWidget>(
    String description,
    WM Function() setupWm,
    dynamic Function(WM wm, WMTester<WM, W> tester, WMContext context)
    testFunction,
    ) {
  setUp(() {
    registerFallbackValue(WMContext());
  });

  test(description, () async {
    final wm = setupWm();
    final element = WMTestableElement<WM, W>(wm);
    await testFunction(wm, element, element);
  });
}

class WMTestableElement<WM extends WidgetModel, W extends WMWidget>
    extends WMContext
    with Diagnosticable
    implements WMElement, WMTester<WM, W> {
  final WM _wm;

  WMTestableElement(this._wm);

  @override
  void init({W? initWidget}) {
    _wm
      ..setupTestElement(this)
      ..setupTestWidget(initWidget)
      ..initWidgetModel()
      ..didChangeDependencies();
  }

  @override
  void update(W newWidget) {
    final oldWidget = _wm.widget;
    _wm
      ..setupTestWidget(newWidget)
      ..didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _wm.didChangeDependencies();
  }

  @override
  void unmount() {
    _wm
      ..dispose()
      ..setupTestElement(null)
      ..setupTestWidget(null);
  }
}

class WMContext extends Mock implements BuildContext {}

abstract class WMTester<WM extends WidgetModel, W extends WMWidget> {
  void init({W? initWidget});

  void update(W newWidget);

  void didChangeDependencies();

  void unmount();
}
