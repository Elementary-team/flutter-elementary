###
<p align="center">
    <img src="https://i.ibb.co/jgkB4ZN/Elementary-Logo.png" alt="Elementary Logo">
</p>

###

<p align="center">
    <a href="https://github.com/MbIXjkee"><img src="https://img.shields.io/badge/Owner-mbixjkee-red.svg" alt="Owner"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://img.shields.io/pub/v/elementary?logo=dart&logoColor=white" alt="Pub Version"></a>
    <a href="https://app.codecov.io/gh/Elementary-team/flutter-elementary"><img src="https://img.shields.io/codecov/c/github/Elementary-team/flutter-elementary?flag=elementary&logo=codecov&logoColor=white" alt="Coverage Status"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://badgen.net/pub/points/elementary" alt="Pub points"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://badgen.net/pub/likes/elementary" alt="Pub Likes"></a>
    <a href="https://pub.dev/packages/elementary"><img src="https://img.shields.io/pub/dm/elementary" alt="Downloads"></a>
    <a href="https://github.com/Elementary-team/flutter-elementary/graphs/contributors"><img src="https://badgen.net/github/contributors/Elementary-team/flutter-elementary" alt="Contributors"></a>
    <a href="https://github.com/Elementary-team/flutter-elementary/blob/main/LICENSE"><img src="https://badgen.net/github/license/Elementary-team/flutter-elementary" alt="License"></a>
</p>

## What this library is

This is an implementation of the [Model-View-ViewModel (MVVM)](https://learn.microsoft.com/en-us/dotnet/architecture/maui/mvvm#the-mvvm-pattern) pattern
for Flutter applications. 

The current implementation follows the rules of the [MVVM](https://learn.microsoft.com/en-us/dotnet/architecture/maui/mvvm#the-mvvm-pattern) architecture pattern, is inspired by the internal implementation of Flutter, and incorporates positive aspects from the [Business Logic Component](https://www.youtube.com/watch?v=RS36gBEp8OI) architecture pattern and Clean Architecture principles.


### Benefits of using

- **Clear Layer Separation:** 
The code is divided into layers with distinct responsibilities, making it easy even for newbie developers to get started with the library.

- **High Independence Between Layers:** 
This decoupling simplifies testing and maintenance. It also allows team members to work independently on different layers while developing a single feature, which leads to decreasing time-to-feature.

- **Ease of Testing:**
The easier it is to test, the more cases are covered. This approach supports various test types, such as unit, widget, golden, and end-to-end tests. Writing tests with Elementary requires minimal additional effort, providing strong motivation to do it.

- **Fully Declarative Widget Layer:**
The widget layer remains purely declarative, devoid of any logic. This aligns with Flutter's focus on declarative UI, with other layers handling the logic.

- **Efficient rebuilds:**
Flutter’s optimized rebuild strategies are crucial for performance. Elementary uses the observer pattern for properties, minimizing unnecessary rebuilds and enhancing application efficiency.
