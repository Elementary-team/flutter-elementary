import 'package:country/data/repository/country/country_repository.dart';
import 'package:country/domain/country/country.dart';
import 'package:country/ui/screen/country_list_screen/country_list_screen.dart';
import 'package:elementary/elementary.dart';

/// Model for [CountryListScreen]
class CountryListScreenModel extends ElementaryModel {
  final CountryRepository _countryRepository;

  CountryListScreenModel(
    this._countryRepository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  /// Return iterable countries.
  Future<Iterable<Country>> loadCountries() async {
    try {
      final res = await _countryRepository.getAllCountries();
      return res;
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
