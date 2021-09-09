import 'dart:async';

import 'package:elementary/elementary.dart';

class TestPageModel extends Model {
  int get value => _value;
  var _value = 0;

  TestPageModel(ErrorHandler errorHandler) : super(errorHandler: errorHandler);

  Future<int> increment([int val = 0]) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (val > 0) {
      _value += val;
    } else {
      ++_value;
    }

    // пример произошедшей ошибки, которую собираемся обработать визуально
    handleError(Exception('Тестовая ошибка'));

    return _value;
  }
}
