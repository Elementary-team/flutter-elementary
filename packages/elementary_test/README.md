# Elementary-test

<img src="https://i.ibb.co/jgkB4ZN/Elementary-Logo.png" alt="Elementary Logo" style="margin:50px 0px">

[![Pub Version](https://img.shields.io/pub/v/elementary_test?logo=dart&logoColor=white)](https://pub.dev/packages/elementary_test)
[![Pub points](https://badgen.net/pub/points/elementary_test)](https://pub.dev/packages/elementary_test)
[![Pub Likes](https://badgen.net/pub/likes/elementary_test)](https://pub.dev/packages/elementary_test)
[![Pub popularity](https://badgen.net/pub/popularity/elementary_test)](https://pub.dev/packages/elementary_test)

## Description

A handy testing library for the apps built with Elementary.
This one’s helpful when used with the Elementary architecture package.

## Overview

This library offers some handy tools to test WidgetModel from the Elementary package.

### testWidgetModel method

The main testing tool is the testWidgetModel function that executes a test.
The parameters it requires are the name of a test, the function preparing WidgetModel for testing,
and the function of the test itself. 

### testFunction

This is a function of a test itself. When passed the WidgetModel, this function describes its behavior and verifies
the result. The function also uses a tester to manipulate the phases of a WidgetModel life cycle,
and the BuildContext mock.

## How to use
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

## Sponsor

Our main sponsor is [Surf](https://surf.ru/).

## Maintainer

[Mikhail Zotyev](https://github.com/MbIXjkee)
