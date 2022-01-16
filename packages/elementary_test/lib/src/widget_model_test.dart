// ignore_for_file: avoid_implementing_value_types, implementation_imports, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:elementary/src/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';

/// Testing function for test WidgetModel.
/// [description] - description of test.
/// [setupWm] - function should return wm that will be test.
/// [testFunction] - function that test wm.
/// [skip] - should skip the test. If passed a String or `true`, the test is
/// skipped. If it's a String, it should explain why the test is skipped;
/// this reason will be printed instead of running the test.
///
/// If [timeout] is passed, it's used to modify or replace the default timeout
/// of 30 seconds. Timeout modifications take precedence in suite-group-test
/// order, so [timeout] will also modify any timeouts set on the group or suite.
///
/// The description will be added to the descriptions of any surrounding
/// [group]s. If [testOn] is passed, it's parsed as a [platform selector][]; the
/// test will only be run on matching platforms.
///
/// If [tags] is passed, it declares user-defined tags that are applied to the
/// test. These tags can be used to select or skip the test on the command line,
/// or to do bulk test configuration. All tags should be declared in the
/// [package configuration file][configuring tags]. The parameter can be an
/// [Iterable] of tag names, or a [String] representing a single tag.
///
/// [onPlatform] allows tests to be configured on a platform-by-platform
/// basis. It's a map from strings that are parsed as PlatformSelectors to
/// annotation classes: [Timeout], [Skip], or lists of those. These
/// annotations apply only on the given platforms.
///
/// If [retry] is passed, the test will be retried the provided number of times
/// before being marked as a failure.
@isTest
void testWidgetModel<WM extends WidgetModel, W extends ElementaryWidget>(
  String description,
  WM Function() setupWm,
  dynamic Function(WM wm, WMTester<WM, W> tester, WMContext context)
      testFunction, {
  String? testOn,
  Timeout? timeout,
  // ignore: avoid_annotating_with_dynamic
  dynamic skip,
  // ignore: avoid_annotating_with_dynamic
  dynamic tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
}) {
  setUp(() {
    registerFallbackValue(WMContext());
  });

  test(
    description,
    () async {
      final wm = setupWm();
      final element = _WMTestableElement<WM, W>(wm);
      await testFunction(wm, element, element);
    },
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
  );
}

/// Interface for emulating BuildContext behaviour.
class WMContext extends Mock implements BuildContext {}

/// Interface for control wm stage in test.
abstract class WMTester<WM extends WidgetModel, W extends ElementaryWidget> {
  /// Initialize widget model to work.
  void init({W? initWidget});

  /// Change the widget used to configure this element.
  void update(W newWidget);

  /// Called when a dependency of this element changes.
  void didChangeDependencies();

  /// Transition from the "inactive" to the "active" lifecycle state.
  void activate();

  /// Transition from the "active" to the "inactive" lifecycle state.
  void deactivate();

  /// Transition from the "inactive" to the "defunct" lifecycle state.
  void unmount();
}

class _WMTestableElement<WM extends WidgetModel, W extends ElementaryWidget>
    extends WMContext
    with Diagnosticable
    implements Elementary, WMTester<WM, W> {
  final WM _wm;

  _WMTestableElement(this._wm);

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
  void activate() {
    _wm.activate();
  }

  @override
  void deactivate() {
    _wm.deactivate();
  }

  @override
  void unmount() {
    _wm
      ..dispose()
      ..setupTestElement(null)
      ..setupTestWidget(null);
  }
}
