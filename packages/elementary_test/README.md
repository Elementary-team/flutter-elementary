# Elementary-test
###
<p align="center">
    <a href="https://documentation.elementaryteam.dev/libs/elementary-test/intro/"><img src="https://i.ibb.co/jgkB4ZN/Elementary-Logo.png" alt="Elementary Logo"></a>
</p>

###

<p align="center">
    <a href="https://github.com/MbIXjkee"><img src="https://img.shields.io/badge/Owner-mbixjkee-red.svg" alt="Owner"></a>
    <a href="https://pub.dev/packages/elementary_test"><img src="https://img.shields.io/pub/v/elementary_test?logo=dart&logoColor=white" alt="Pub Version"></a>
    <a href="https://pub.dev/packages/elementary_test"><img src="https://badgen.net/pub/points/elementary_test" alt="Pub points"></a>
    <a href="https://pub.dev/packages/elementary_test"><img src="https://badgen.net/pub/likes/elementary_test" alt="Pub Likes"></a>
    <a href="https://pub.dev/packages/elementary_test"><img src="https://img.shields.io/pub/dm/elementary_test" alt="Downloads"></a>
</p>


## Description

A handy testing library for apps built with Elementary.

## Overview

This library offers some handy tools to test `WidgetModel` from the Elementary package.

### testWidgetModel method

The main testing tool is the `testWidgetModel` function, which executes a test. The parameters it requires are the name of the test, the function preparing the `WidgetModel` for testing, and the test function itself.

### a testFunction parameter

This is a function of the test itself. When passed the `WidgetModel`, this function describes its behavior and verifies the result. The function also uses a tester to manipulate the phases of the `WidgetModel` lifecycle and a `BuildContext` mock.

## How to use
```dart
void main() {
  late TestPageModelMock model;

  TestPageWidgetModel setUpWm() {
    model = TestPageModelMock();
    when(() => model.value).thenReturn(0);
    when(() => model.increment()).thenAnswer((invocation) => Future.value(1));

    return TestPageWidgetModel(model);
  }

  testWidgetModel<TestPageWidgetModel, TestPageWidget>(
    'calculatingState should return true while incrementing before the answer was recieved',
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

      expect(wm.calculatingState.value, isTrue);
    },
  );

  testWidgetModel<TestPageWidgetModel, TestPageWidget>(
    'calculatingState should return false after get the answer of incrementing',
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
        const Duration(milliseconds: 31),
      );

      expect(wm.calculatingState.value, isFalse);
    },
  );

  testWidgetModel<TestPageWidgetModel, TestPageWidget>(
    'should happen smth depend on lifecycle',
    setUpWm,
    (wm, tester, context) async {
      tester.init();

      // Emulate didChangeDependencies happened.
      tester.didChangeDependencies();

      // Test what ever we expect happened in didChangeDependencies;
      // ...
    },
  );
}

class TestPageModelMock extends Mock with MockElementaryModelMixin implements TestPageModel {}
```

## Maintainer

<a href="https://github.com/MbIXjkee">
    <div style="display: inline-block;">
        <img src="https://i.ibb.co/6Hhpg5L/circle-ava-jedi.png" height="64" width="64" alt="Maintainer avatar">
        <p style="float:right; margin-left: 8px;">Mikhail Zotyev</p>
    </div>
</a>

## Contributors thanks

Big thanks to all these people, who put their effort into helping the project.

![contributors](https://contributors-img.firebaseapp.com/image?repo=Elementary-team/flutter-elementary)
<a href="https://github.com/Elementary-team/flutter-elementary/graphs/contributors"></a>

Special thanks to:

[Dmitry Krutskikh](https://github.com/dkrutskikh), [Konoshenko Vlad](https://github.com/vlkonoshenko), and 
[Denis Grafov](https://github.com/grafovdenis) for the early adoption and the first production feedback;

[Alex Bukin](https://github.com/AlexeyBukin) for IDE plugins;

All members of the Surf Flutter Team for actively using and providing feedback.

## Sponsorship & Support

Special sponsor of the project:

<a href="https://surf.dev/">
<img src="https://surf.dev/wp-content/themes/surf/assets/img/logo.svg" alt="Surf"/>
</a>

For all questions regarding sponsorship/collaboration connect with [Mikhail Zotyev](https://github.com/MbIXjkee).

We appreciate any form of support, whether it's a financial donation, a public sharing, or a star on GitHub and a like on Pub. If you want to provide financial support, there are several ways you can do it:

  - [GH Sponsors](https://github.com/sponsors/MbIXjkee)
  - [Buy me a coffee](https://buymeacoffee.com/mbixjkee)
  - [Patreon](https://www.patreon.com/MbIXJkee)
  - [Boosty](https://boosty.to/mbixjkee)

Thank you for all your support!
