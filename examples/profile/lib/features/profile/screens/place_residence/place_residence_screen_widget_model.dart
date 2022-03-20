import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/domain/entity/app_coordinate.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen_model.dart';
import 'package:profile/features/profile/screens/place_residence/widgets/field_with_suggestions_widget/field_with_suggestions_widget.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_state.dart';
import 'package:profile/util/dialog_controller.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Factory for [PlaceResidenceScreenWidgetModel].
PlaceResidenceScreenWidgetModel placeResidenceScreenWidgetModelFactory(
  BuildContext context,
) {
  final appDependencies = context.read<IAppScope>();
  final model = PlaceResidenceScreenModel(
    appDependencies.profileBloc,
    appDependencies.mockCitiesRepository,
    appDependencies.errorHandler,
  );
  final coordinator = appDependencies.coordinator;
  final dialogController = appDependencies.dialogController;
  return PlaceResidenceScreenWidgetModel(
    model: model,
    coordinator: coordinator,
    dialogController: dialogController,
  );
}

/// Widget Model for [PlaceResidenceScreen].
class PlaceResidenceScreenWidgetModel
    extends WidgetModel<PlaceResidenceScreen, PlaceResidenceScreenModel>
    implements IPlaceResidenceScreenWidgetModel {
  /// Coordinator for navigation.
  final Coordinator coordinator;

  /// Controller for show [BottomSheet].
  final DialogController dialogController;

  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  TextEditingController get controller => _controller;

  @override
  FocusNode get focusNode => _focusNode;

  @override
  GlobalKey<FormState> get formKey => _formKey;

  String? _selectedCityOnMap;

  /// Create an instance [PlaceResidenceScreenWidgetModel].
  PlaceResidenceScreenWidgetModel({
    required PlaceResidenceScreenModel model,
    required this.coordinator,
    required this.dialogController,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _initPlaceResidence();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  String? placeResidenceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Select a city from the list or on the map';
    } else {
      return null;
    }
  }

  @override
  void showBottomSheet({
    required WidgetBuilder builder,
    required ShapeBorder shape,
  }) {
    dialogController.showBottomSheet(
      context: context,
      builder: builder,
      shape: shape,
    );
  }

  @override
  void updateSelectedCityOnMap() {
    if (_selectedCityOnMap != null) {
      _controller.text = _selectedCityOnMap!;
    }
  }

  @override
  Future<void> getCityByCoordinates(Point coordinates) async {
    _selectedCityOnMap = await model.getCityByCoordinates(coordinates);
  }

  @override
  void updatePlace() {
    if (_formKey.currentState!.validate()) {
      model.savePlaceResidence(_controller.text);
      coordinator.navigate(context, AppCoordinates.interestsScreen);
    }
  }

  @override
  void onTapAnEmptySpace() {
    _focusNode.unfocus();
  }

  void _initPlaceResidence() {
    final state = model.currentState;
    if (state is ProfileContentState) {
      final currentState = state as IEditingAvailable;
      final profile = currentState.profile;
      if (profile.placeOfResidence != null) {
        _controller.text = profile.placeOfResidence!;
      }
    }
  }
}

/// Interface of [PlaceResidenceScreenWidgetModel].
abstract class IPlaceResidenceScreenWidgetModel extends IWidgetModel {
  /// Text Editing controller for [FieldWithSuggestionsWidget].
  TextEditingController get controller;

  /// FocusNode for [FieldWithSuggestionsWidget].
  FocusNode get focusNode;

  /// Key to [Form].
  GlobalKey<FormState> get formKey;

  /// Validator for checking the correctness of the entered city.
  String? placeResidenceValidator(String? value);

  /// Returns the mock value of the city at the coordinates selected on the map.
  void getCityByCoordinates(Point coordinates);

  /// Save the value of the selected city on the map.
  void updateSelectedCityOnMap();

  /// Function to open bottom sheet.
  void showBottomSheet({
    required WidgetBuilder builder,
    required ShapeBorder shape,
  });

  /// Function to save place of residence in [Profile].
  void updatePlace();

  /// Callback on tap an empty space.
  void onTapAnEmptySpace();
}
