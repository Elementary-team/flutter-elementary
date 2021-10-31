import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for [ThemeWrapper].
void main() {
  final testKey = UniqueKey();

  final Widget testWidget = MaterialApp(
    theme: ThemeData(),
    home: Container(
      key: testKey,
    ),
  );

  late ThemeWrapper themeWrapper;

  setUp(() {
    themeWrapper = ThemeWrapper();
  });

  testWidgets(
    'getTheme should find same Theme as Theme.of',
    (tester) async {
      await tester.pumpWidget(testWidget);

      final context = tester.element(find.byKey(testKey));

      final themeFound = themeWrapper.getTheme(context);
      final themeFound2 = Theme.of(context);

      expect(themeFound, same(themeFound2));
    },
  );

  testWidgets(
    'getTextTheme should find same TextTheme as Theme.of',
    (tester) async {
      await tester.pumpWidget(testWidget);

      final context = tester.element(find.byKey(testKey));

      final themeFound = themeWrapper.getTextTheme(context);
      final themeFound2 = Theme.of(context).textTheme;

      expect(
        themeFound,
        same(themeFound2),
      );
    },
  );
}
