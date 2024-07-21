## Widget as a View description
`ElementaryWidget` represents a View layer in the triad `ElementaryWidget-WidgetModel-ElementaryModel`. In the MVVM concept, [views are responsible](https://learn.microsoft.com/en-us/dotnet/architecture/maui/mvvm#view) for defining the structure, layout, and appearance of what the user sees on screen.


It is important to remember that Flutter is a declarative framework, and any Flutter widget is not a view, but a configuration/description. So, it is more accurate to say that `ElementaryWidget` is a view description, a component widget that uses other widgets to describe a composition that needs to be shown to the user. By hiding how the framework works behind the widget concept, we can simplify to equate `ElementaryWidget` with View.

The significant difference from other composition widgets is the simplified build process. Since business logic and presentation logic are encapsulated in the Model and Widget Model, it is only left to the widget to follow the `UI = f(s)` principle and describe this UI based on the `WidgetModel` contract. Therefore, the build method doesn't have context and accepts only the `WidgetModel` contract as an argument.

Here is an example of `ElementaryWidget`'s build method for a case of loading data from the network:

```dart
@override
Widget build(IExampleWidgetModel wm) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Example Screen'),
    ),
    body: EntityStateNotifierBuilder<ExampleEntity>(
      listenableEntityState: wm.exampleState,
      loadingBuilder: (_, __) => const _LoadingWidget(),
      errorBuilder: (_, __, ___) => const _ErrorWidget(),
      builder: (_, data) => _ContentWidget(data: data),
    ),
  );
}
```

## Widget as a starting and updating configuration
Apart from describing a subtree, `ElementaryWidget` is a configuration. On one side, it is a configuration of the MVVM layers, meaning this widget defines a factory to be used for creating a corresponding `WidgetModel` instance. On the other side, it is a Flutter way to set and update externally defined parameters. For example, for a screen that shows detailed information about a product, it could be the product's ID. However, it can be any information defined higher up in the tree, and an update to the configuration automatically leads to a call for lifecycle methods.
