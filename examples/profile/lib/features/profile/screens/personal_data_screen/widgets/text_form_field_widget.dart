import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';

/// TextFormField widgets.
class TextFormFieldWidget extends StatelessWidget {
  /// Controller for text field.
  final TextEditingController? controller;

  /// Hint text for text field.
  final String hintText;

  ///Function for validation.
  final String? Function(String?)? validator;

  /// Create an instance [TextFormFieldWidget].
  const TextFormFieldWidget({
    required this.hintText,
    this.controller,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18.0,
          color: textFieldBorderColor,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: textFieldBorderColor),
        ),
      ),
      validator: validator,
    );
  }
}
