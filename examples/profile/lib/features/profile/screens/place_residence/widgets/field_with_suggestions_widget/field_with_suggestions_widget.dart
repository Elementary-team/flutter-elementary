import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';
import 'package:profile/assets/strings/place_residence_screen_strings.dart';
import 'package:profile/features/profile/screens/place_residence/widgets/field_with_suggestions_widget/field_with_suggestions_widget_model.dart';

/// Field with suggestions widget.
class FieldWithSuggestionsWidget
    extends ElementaryWidget<IFieldWithSuggestionsWidgetModel> {
  /// Text editing controller.
  final TextEditingController controller;

  /// Validator for [TextFormField].
  final FormFieldValidator<String> validator;

  /// Focus node.
  final FocusNode focusNode;

  /// Create an instance [FieldWithSuggestionsWidget].
  const FieldWithSuggestionsWidget({
    required this.controller,
    required this.validator,
    required this.focusNode,
    Key? key,
    WidgetModelFactory wmFactory = fieldWithSuggestionsWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IFieldWithSuggestionsWidgetModel wm) {
    return CompositedTransformTarget(
      link: wm.optionsLayerLink,
      child: TextFormField(
        controller: wm.controller,
        focusNode: focusNode,
        validator: validator,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          hintText: PlaceResidenceScreenStrings.placeResidenceTitle,
          hintStyle: TextStyle(
            fontSize: 18.0,
            color: textFieldBorderColor,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: textFieldBorderColor),
          ),
        ),
      ),
    );
  }
}
