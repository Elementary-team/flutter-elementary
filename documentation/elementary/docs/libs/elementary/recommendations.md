## How to test
Since all layers are well-separated from each other, they are easy to test with many options available.

- The Model layer contains only business logic, so use unit tests for it.
- Use widget-model tests from the elementary_test library for `WidgetModel`s. These tests are also unit tests but with ready-to-use controls for emulating the lifecycle.
- Use widget and golden tests for the Widget layer. This should be easy because you don't need to mock all internal things, only the values from the `WidgetModel` contract.
- Use integration tests to check the workflow together.

## Utils

There are many helpers available for Elementary. Check [elementary_helper](https://pub.dev/packages/elementary_helper) to find them. Their purpose is to make using Elementary smooth. However, as mentioned, you can use them if you prefer, but you are not obligated to if you prefer something else.
