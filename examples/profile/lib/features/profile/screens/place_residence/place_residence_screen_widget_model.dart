import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/domain/entity/app_coordinate.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen_model.dart';
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

  final TextEditingController _controller = TextEditingController();
  final _listSuggestionsState = EntityStateNotifier<List<String>>();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  TextEditingController get controller => _controller;

  @override
  ListenableState<EntityState<List<String>>> get listSuggestionsState =>
      _listSuggestionsState;

  @override
  FocusNode get focusNode => _focusNode;

  @override
  GlobalKey<FormState> get formKey => _formKey;

  String? _currentPlaceResidence;
  String? _selectedCityOnMap;

  Timer? _debounceTimer;
  var _listCities = <String>[];

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
    _controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_controllerListener);
    super.dispose();
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
  FutureOr<List<String>> optionsBuilder(
    TextEditingValue textEditingValue,
  ) async {
    if (textEditingValue.text == '') {
      return List<String>.empty();
    }
    return _listCities;
  }

  @override
  String? placeResidenceValidator(String? value) {
    if (value == null || value.isEmpty || _currentPlaceResidence != value) {
      return 'Select a city from the list or on the map';
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
      _currentPlaceResidence = _selectedCityOnMap;
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
      if (_currentPlaceResidence != null) {
        model.savePlaceResidence(_currentPlaceResidence);
        coordinator.navigate(context, AppCoordinates.interestsScreen);
      }
    }
  }

  void _controllerListener() {
    _debouncing(_controller.text);
  }

  void _debouncing(String city) {
    _debounceTimer?.cancel();
    _listSuggestionsState.loading();
    try {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
        _listCities = await model.getListCities(city);
        _listSuggestionsState.content(_listCities);
      });
    } on Exception catch (_) {
      _listSuggestionsState.error();
    }
  }

  void _initPlaceResidence() {
    final state = model.currentState;
    if (state is IEditingAvailable) {
      final currentState = state as IEditingAvailable;
      final profile = currentState.profile;
      if (profile.placeOfResidence != null) {
        _controller.text = profile.placeOfResidence!;
        _currentPlaceResidence = profile.placeOfResidence;
      }
    }
  }
}

/// Interface of [PlaceResidenceScreenWidgetModel].
abstract class IPlaceResidenceScreenWidgetModel extends IWidgetModel {
  /// Text Editing controller for [RawAutocomplete].
  TextEditingController get controller;

  /// FocusNode for [RawAutocomplete].
  FocusNode get focusNode;

  /// Suggestions status.
  ListenableState<EntityState<List<String>>> get listSuggestionsState;

  /// Key to [Form].
  GlobalKey<FormState> get formKey;

  /// Function to change place residence.
  void updatePlaceResidence(String? newValue);

  /// Callback on field submitted.
  void onFieldSubmitted();

  /// Function to get suggestion for entering a city.
  FutureOr<List<String>> optionsBuilder(TextEditingValue enteredValue);

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
}
