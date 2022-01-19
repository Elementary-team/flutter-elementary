import 'package:elementary/elementary.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';
import 'package:profile/features/profile/service/bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/repository/mock_cities_repository.dart';
import 'package:profile/features/profile/service/repository/mock_profile_repository.dart';

/// Model for [PlaceResidenceScreen].
class PlaceResidenceScreenModel extends ElementaryModel {
  /// Bloc for working with profile states.
  final ProfileBloc _profileBloc;

  /// Mock repository for get list suggestions.
  final MockCitiesRepository _repository;

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
}
