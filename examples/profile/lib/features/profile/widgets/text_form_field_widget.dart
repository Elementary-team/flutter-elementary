import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';

/// TextFormField widget.
class TextFormFieldWidget extends StatelessWidget {
  /// Controller for text field.
  final TextEditingController controller;

  /// Callback for when the field is filled.
  final Function(String?) onChanged;

  /// Hint text for text field.
  final String hintText;

  ///Function for validation.
  final String? Function(String?)? validator;

  /// Key for Form.
  final GlobalKey? formKey;

  /// Create an instance [TextFormFieldWidget].
  const TextFormFieldWidget({
    required this.controller,
    required this.onChanged,
    required this.hintText,
    this.formKey,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
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
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
