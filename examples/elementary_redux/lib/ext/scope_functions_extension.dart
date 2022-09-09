extension ScopeFunctionsExtension<T extends Object> on T {
  /// https://kotlinlang.org/docs/scope-functions.html#let
  ReturnType let<ReturnType>(ReturnType Function(T it) operationFor) {
    return operationFor(this);
  }
}
