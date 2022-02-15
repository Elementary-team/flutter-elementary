import 'dart:async';

import 'package:elementary/elementary.dart';

/// Model example. Business logic using
class TestPageModel extends ElementaryModel {
  int get value => _value;
  var _value = 0;

  TestPageModel(ErrorHandler errorHandler) : super(errorHandler: errorHandler);

  Future<int> increment() async {
    // Emulate some long process like a request to server
    await Future<void>.delayed(const Duration(seconds: 1));

    ++_value;

    return _value;
  }
}
