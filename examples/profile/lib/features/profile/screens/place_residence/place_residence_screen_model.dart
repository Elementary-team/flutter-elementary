import 'package:elementary/elementary.dart';
import 'package:profile/features/cities_repository/mock_cities_repository.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_event.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_state.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Model for [PlaceResidenceScreen].
class PlaceResidenceScreenModel extends ElementaryModel {
  /// Bloc for working with profile states.
  final ProfileBloc _profileBloc;

  /// Mock repository for get list suggestions.
  final ICitiesRepository _repository;

  /// Gives the current state.
  BaseProfileState get currentState => _profileBloc.state;

  /// Create an instance [PlaceResidenceScreenModel].
  PlaceResidenceScreenModel(
    this._profileBloc,
    this._repository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  /// Function to get suggestion for entering a city from a mock server.
  Future<List<String>> getListCities(String enteredValue) {
    return _repository.getListCities(enteredValue);
  }

  /// Returns the mock value of the city at the coordinates selected on the map.
  Future<String> getCityByCoordinates(Point coordinates) {
    return _repository.getCityByCoordinates(coordinates);
  }

  /// Method for save place of residence.
  void savePlaceResidence(String? place) {
    _profileBloc.add(UpdatePlaceResidenceEvent(placeResidence: place));
  }
}
