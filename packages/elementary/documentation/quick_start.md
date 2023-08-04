# Document describes a simple guideline how to start with Elementary [WIP]

### Choose tooling:

Depends on your IDE and personal preferences choose and install one of those tools:

- [plugin for IntelliJ](https://plugins.jetbrains.com/plugin/18099-elementary)
- [plugin for VSCode](https://marketplace.visualstudio.com/items?itemName=ElementaryTeam.elementary)
- [elementary brick](https://brickhub.dev/bricks/elementary)
- [elementary_cli](https://pub.dev/packages/elementary_cli);

Or can skip this step and create Widgets, Widget Models, Models manually further.

### Depend on elementary:

Run this command

```flutter pub add elementary```

or manually add dependency to your project pubspec.yaml

```
dependencies:
  elementary: $actual_version
```
### Depend on elementary_helper:

Run this command

```flutter pub add elementary_helper```

or manually add dependency to your project pubspec.yaml

```
dependencies:
  elementary_helper: $actual_version
```

### Depend on elementary_test:

Run this command

```flutter pub add elementary_test```

or manually add dependency to your project pubspec.yaml

```
dependencies:
  elementary_test: $actual_version
```

### Create classes:

Using a chosen tool create classes for ElementaryModel, WidgetModel, ElementaryWidget.

TODO: describe manual creation.

### ElementaryModel:

Implement all business logic for current feature in model, free style. 

TODO: more details, examples.

### WidgetModel:

Implement all presentation logic for current feature in widget model.

TODO: more details, examples.

### ElementaryWidget:

Based on the contract of Widget Model, describe UI.

TODO: more details, examples.

### Testing:

Write unit tests for Model.
Write tests for Widget Model using elementary_test.
Write widget test, golden tests for ElementaryWidget.

TODO: more details, examples.