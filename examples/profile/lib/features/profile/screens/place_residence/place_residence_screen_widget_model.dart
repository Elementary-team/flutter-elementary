import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/domain/entity/app_coordinate.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen_model.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';
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
  String? _selectedCityOnMap;

  /// Create an instance [PlaceResidenceScreenWidgetModel].
  PlaceResidenceScreenWidgetModel(
    PlaceResidenceScreenModel model,
  ) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _coordinator = context.read<IAppScope>().coordinator;
    _initProfile();
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
  List<String> getSuggestion(String enteredValue) {
    return model.getMockListCities(enteredValue);
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
    showModalBottomSheet<Point>(
      context: context,
      builder: builder,
      shape: shape,
      isScrollControlled: true,
    );
  }

  @override
  void saveSelectedCityOnMap() {
    if (_selectedCityOnMap != null) {
      _currentPlaceResidence = _selectedCityOnMap;
      _controller.text = _selectedCityOnMap!;
    }
  }

  @override
  void getMockCityByCoordinates(Point coordinates) {
    _selectedCityOnMap = model.getMockCityByCoordinates(coordinates);
  }

  @override
  void savePlaceInProfile() {
    if (_formKey.currentState!.validate()) {
      if (_currentPlaceResidence != null) {
        model.savePlaceResidence(_currentPlaceResidence);
        _coordinator.navigate(context, AppCoordinate.interestsScreen);
      }
    }
  }

  void _initProfile() {
    final state = model.currentState;
    if (state is ProfileState) {
      final profile = state.profile;
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
  ListenableState<List<String>> get listSuggestionsState;

  /// Key to [Form].
  GlobalKey<FormState> get formKey;

  /// Function to change place residence.
  void updatePlaceResidence(String? newValue) {}

  /// Callback on field submitted.
  void onFieldSubmitted() {}

  /// Function to get suggestion for entering a city.
  List<String> getSuggestion(String enteredValue) {
    return <String>[];
  }

  /// Validator for checking the correctness of the entered city.
  String? placeResidenceValidator(String? value) {}

  /// Returns the mock value of the city at the coordinates selected on the map.
  void getMockCityByCoordinates(Point coordinates) {}

  /// Save the value of the selected city on the map.
  void saveSelectedCityOnMap() {}

  /// Function to open bottom sheet.
  void showBottomSheet({
    required WidgetBuilder builder,
    required ShapeBorder shape,
  }) {}

  /// Function to save place of residence in [Profile].
  void savePlaceInProfile() {}
}
