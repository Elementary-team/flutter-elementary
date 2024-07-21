## testWidgetModel method

The main testing tool is the `testWidgetModel` function, which executes a test. The parameters it requires are the name of the test, the function preparing the `WidgetModel` for testing, and the test function itself.

## testFunction parameter

This is a function of the test itself. When passed the `WidgetModel`, this function describes its behavior and verifies the result. The function also uses a tester to manipulate the phases of the `WidgetModel` lifecycle and a `BuildContext` mock.

## Example
```dart
void main() {
  late TestPageModelMock model;
  late ThemeWrapperMock theme;
  late TextThemeMock textTheme;

  TestPageWidgetModel setUpWm() {
    textTheme = TextThemeMock();
    when(() => textTheme.headline4).thenReturn(null);
    theme = ThemeWrapperMock();
    when(() => theme.getTextTheme(any())).thenReturn(textTheme);
    model = TestPageModelMock();
    when(() => model.value).thenReturn(0);
    when(() => model.increment()).thenAnswer((invocation) => Future.value(1));

    return TestPageWidgetModel(model, theme);
  }

  testWidgetModel<TestPageWidgetModel, TestPageWidget>(
    'counterStyle should be headline4',
    setUpWm,
        (wm, tester, context) {
      final style = TextStyleMock();
      when(() => textTheme.headline4).thenReturn(style);

      tester.init();

      expect(wm.counterStyle, style);
    },
  );
  
  testWidgetModel<TestPageWidgetModel, TestPageWidget>(
    'when call increment and before get answer valueState should be loading',
    setUpWm,
        (wm, tester, context) async {
      tester.init();

      when(() => model.increment()).thenAnswer(
            (invocation) => Future.delayed(
          const Duration(milliseconds: 30),
              () => 1,
        ),
      );

      unawaited(wm.increment());

      await Future<void>.delayed(
        const Duration(milliseconds: 10),
      );

      final value = wm.valueState.value;

      expect(value, isNotNull);
      expect(value!.isLoading, isTrue);
    },
  );
}
```
