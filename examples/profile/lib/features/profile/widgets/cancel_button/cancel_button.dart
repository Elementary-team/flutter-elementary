import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/profile/widgets/cancel_button/cancel_button_widget_model.dart';

/// Cancel button.
class CancelButton extends ElementaryWidget<CancelButtonWidgetModel> {
  /// Create an instance [CancelButton].
  const CancelButton({
    Key? key,
    WidgetModelFactory wmFactory = cancelButtonWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ICancelButtonWidgetModel wm) {
    return IconButton(
      onPressed: wm.cancel,
      icon: const Icon(Icons.cancel),
    );
  }
}
