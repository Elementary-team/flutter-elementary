import 'package:elementary/elementary.dart';
import 'package:profile/features/cities/service/repository/mock_cities_repository.dart';
import 'package:profile/features/profile/screens/place_residence/widgets/field_with_suggestions_widget/field_with_suggestions_widget.dart';

/// Model for [FieldWithSuggestionsWidget].
class FieldWithSuggestionsModel extends ElementaryModel {
  final ICitiesRepository _citiesRepository;

  /// Create an instance [FieldWithSuggestionsModel].
  FieldWithSuggestionsModel(this._citiesRepository);

  /// Function to get suggestion for entering a city from a mock server.
  Future<List<String>> getListCities(String enteredValue) {
    return _citiesRepository.getListCities(enteredValue);
  }
}
