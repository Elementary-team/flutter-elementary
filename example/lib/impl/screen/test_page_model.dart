import 'dart:async';

import 'package:elementary/elementary.dart';

class TestPageModel extends Model {
  int get value => _value;

  var _value = 0;

  Future<int> increment([int val = 0]) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (val > 0) {
      _value += val;
    } else {
      ++_value;
    }

    return _value;
  }
}