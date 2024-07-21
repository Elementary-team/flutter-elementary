## General Overview

A good way to demonstrate the library's functionality without technical details is with this scheme: in the WidgetModel, we determine what to display to the user and manage the business processes running behind the scenes.

<img src="https://i.ibb.co/rk4sxDf/3.gif" alt="Elementary scheme">

## Technical Overview

Elementary follows classical MVVM layering, comprising the View, ViewModel, and Model layers. Each layer is represented by a specific entity: `ElementaryWidget` for the View layer, `WidgetModel` for the ViewModel layer, and `ElementaryModel` for the Model layer.

To naturally integrate this chain of entities into the Flutter trees, the following decisions were made:

- An `ElementaryWidget`, like all other widgets, is simply a configuration and an immutable description of a part of the user interface.
- An `ElementaryWidget` is a component widget (represented by a [ComponentElement](https://api.flutter.dev/flutter/widgets/ComponentElement-class.html)), meaning it describes its subtree as a combination of other widgets.
- A representation of an `ElementaryWidget` in the Element tree is a special [Element](https://api.flutter.dev/flutter/widgets/Element-class.html) called `Elementary`.
- `Elementary` creates a `WidgetModel` using a factory method from `ElementaryWidget` and then stores and manages it.
- The lifecycle of the `WidgetModel` is connected to the `Elementary` lifecycle, as indicated in the previous statement.
- A `WidgetModel` depends on an `ElementaryModel`, stores it, and manages its lifecycle.
- When a subtree needs to be described, `Elementary` delegates to the `build` method of `ElementaryWidget`, providing the `WidgetModel`. This represents `UI=f(State)` in the form `subtree=build(WM)`.

The following diagram illustrates how these components work when an ElementaryWidget is inserted into the tree:

<img src="https://i.ibb.co/hYcYRbs/elementary-In-Tree.gif" alt="Elementary scheme in tree">
