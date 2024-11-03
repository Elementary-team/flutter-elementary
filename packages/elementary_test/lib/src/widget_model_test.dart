// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:elementary/elementary.dart';
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
      when(() => element.mounted).thenReturn(true);
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

/// Interface for controlling WidgetModel's stage during tests.
/// Every method in this interface represents possible changes with Widget Model
/// and allows to emulate this happened.
///
/// For additional information check the lifecycle of the [WidgetModel].
abstract class WMTester<WM extends WidgetModel, W extends ElementaryWidget> {
  /// Emulates initializing WidgetModel to work.
  ///
  /// Represents processes happen with WidgetModel when it is inseted into the
  /// tree, before the first build of the subtree.
  void init({W? initWidget});

  /// Emulates changing a widget instance associated
  /// with the according Elementary.
  void update(W newWidget);

  /// Emulates changing of dependencies WidgetModel has subscribed
  /// by BuildContext.
  void didChangeDependencies();

  /// Emulates the transition from the "inactive"
  /// to the "active" lifecycle state.
  ///
  /// In real work happens when the WidgetModel is reinserted into
  /// the tree after having been removed via [deactivate].
  void activate();

  /// Emulates the transition from the "active"
  /// to the "inactive" lifecycle state.
  ///
  /// In real work happens when the WidgetModel is removed from the tree.
  void deactivate();

  /// Emulates the transition from the "inactive"
  /// to the "defunct" lifecycle state.
  ///
  /// In real work happens when the WidgetModel is removed from the
  /// tree permanently.
  /// See also:
  /// [WidgetModel.dispose];
  void unmount();

  /// Emulates notification WidgetModel about an error from the Model.
  void handleError(Object error);
}

class _WMTestableElement<WM extends WidgetModel, W extends ElementaryWidget>
    extends WMContext with Diagnosticable implements WMTester<WM, W> {
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

  @override
  void handleError(Object error) {
    // TODO(mjk): implement after adding the method to main package.
  }
}
