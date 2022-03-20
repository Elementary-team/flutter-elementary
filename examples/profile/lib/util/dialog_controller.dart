import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Controller to open dialogs.
class DialogController {
  /// Create an instance [DialogController].
  const DialogController();

  /// Shows a [SnackBar].
  void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  /// Shows a [BottomSheet].
  void showBottomSheet({
    required BuildContext context,
    required WidgetBuilder builder,
    required ShapeBorder shape,
  }) {
    showModalBottomSheet<Point>(
      context: context,
      builder: builder,
      shape: shape,
      isScrollControlled: true,
    );
  }

  /// Shows [DatePickerDialog].
  Future<DateTime?> showPicker(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
  }
}
