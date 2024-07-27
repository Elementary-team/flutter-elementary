import 'package:country/features/business/country/domain/contract/country_repository.dart';
import 'package:country/features/business/country/domain/model/country.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen.dart';
import 'package:elementary/elementary.dart';

/// Model for [CountryListScreen].
class CountryListScreenModel extends ElementaryModel {
  final ICountryRepository _countryRepository;

  CountryListScreenModel(
    this._countryRepository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  /// Provides a list of countries.
  Future<List<Country>> loadCountries() async {
    try {
      final res = await _countryRepository.loadAllCountries();
      return res;
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
