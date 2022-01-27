import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Controller to open [SnackBar] and [BottomSheet].
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
}
