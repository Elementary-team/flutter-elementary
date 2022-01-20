import 'package:elementary/elementary.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';
import 'package:profile/features/profile/service/bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/bloc/profile_event.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';
import 'package:profile/features/profile/service/repository/mock_cities_repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Model for [PlaceResidenceScreen].
class PlaceResidenceScreenModel extends ElementaryModel {
  /// Bloc for working with profile states.
  final ProfileBloc _profileBloc;

  /// Mock repository for get list suggestions.
  final MockCitiesRepository _repository;

  /// Gives the current state.
  BaseProfileState get currentState => _profileBloc.state;

  /// Create an instance [PlaceResidenceScreenModel].
  PlaceResidenceScreenModel(
    this._profileBloc,
    this._repository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  /// Function to get suggestion for entering a city from a mock server.
  List<String> getMockListCities(String enteredValue) {
    return _repository.getMockListCities(enteredValue);
  }

  /// Returns the mock value of the city at the coordinates selected on the map.
  String getMockCityByCoordinates(Point coordinates) {
    return _repository.getMockCityByCoordinates(coordinates);
  }

  /// /// Method for save place of residence.
  void savePlaceResidence(String? place) {
    if (_profileBloc.state is ProfileState) {
      final state = _profileBloc.state as ProfileState;
      var currentProfile = state.profile;
      if(currentProfile.placeOfResidence != place) {
        currentProfile = currentProfile.copyWith(placeOfResidence: place);
        _profileBloc.add(SavePlaceResidenceEvent(currentProfile));
      }
    }
  }
}
