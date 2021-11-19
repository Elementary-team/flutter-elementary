import 'dart:async';

import 'package:elementary/elementary.dart';

class TestPageModel extends ElementaryModel {
  int get value => _value;
  var _value = 0;

  TestPageModel(ErrorHandler errorHandler) : super(errorHandler: errorHandler);

  Future<int> increment() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    ++_value;

    return _value;
  }
}
