import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen_model.dart';
import 'package:profile/features/profile/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Factory for [PlaceResidenceScreenWidgetModel].
PlaceResidenceScreenWidgetModel placeResidenceScreenWidgetModelFactory(
  BuildContext context,
) {
  final appDependencies = context.read<IAppScope>();
  final model = PlaceResidenceScreenModel(
    appDependencies.profileBloc,
    appDependencies.repository,
    appDependencies.errorHandler,
  );
  return PlaceResidenceScreenWidgetModel(model);
}

/// Widget Model for [PlaceResidenceScreen].
class PlaceResidenceScreenWidgetModel
    extends WidgetModel<PlaceResidenceScreen, PlaceResidenceScreenModel>
    implements IPlaceResidenceScreenWidgetModel {
  final TextEditingController _controller = TextEditingController();
  final _listSuggestionsState = StateNotifier<List<String>>();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final Coordinator _coordinator;

  @override
  TextEditingController get controller => _controller;

  @override
  ListenableState<List<String>> get listSuggestionsState =>
      _listSuggestionsState;

  @override
  FocusNode get focusNode => _focusNode;

  @override
  GlobalKey<FormState> get formKey => _formKey;

  String? _currentPlaceResidence;

  /// Create an instance [PlaceResidenceScreenWidgetModel].
  PlaceResidenceScreenWidgetModel(
    PlaceResidenceScreenModel model,
  ) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _coordinator = context.read<IAppScope>().coordinator;
  }
  @override
  void updatePlaceResidence(String? newValue) {
    _focusNode.unfocus();
    _currentPlaceResidence = newValue;
  }

  @override
  void onFieldSubmitted() {
    _formKey.currentState!.validate();
  }

  @override
  FutureOr<List<String>> getSuggestion(String enteredValue) {
    return model.getMockListCities(enteredValue);
  }

  @override
  String? placeResidenceValidator(String? value) {
    if (value == null || value.isNotEmpty || _currentPlaceResidence != value) {
      return 'Choose a city from the list';
    }
  }

  @override
  void showBottomSheet({
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

/// Interface of [PlaceResidenceScreenWidgetModel].
abstract class IPlaceResidenceScreenWidgetModel extends IWidgetModel {
  /// Text Editing controller for [RawAutocomplete].
  TextEditingController get controller;

  /// FocusNode for [RawAutocomplete].
  FocusNode get focusNode;

  /// Suggestions status.
  ListenableState<List<String>> get listSuggestionsState;

  /// Key to [Form].
  GlobalKey<FormState> get formKey;

  /// Function to change place residence.
  void updatePlaceResidence(String? newValue) {}

  /// Callback on field submitted.
  void onFieldSubmitted() {}

  /// Function to get suggestion for entering a city.
  FutureOr<List<String>> getSuggestion(String enteredValue) {
    return <String>[];
  }

  /// Validator for checking the correctness of the entered city.
  String? placeResidenceValidator(String? value) {}

  /// Function to open bottom sheet.
  void showBottomSheet({
    required WidgetBuilder builder,
    required ShapeBorder shape,
  }) {}
}
