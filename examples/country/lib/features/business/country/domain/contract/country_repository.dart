import 'package:country/features/business/country/domain/model/country.dart';

/// A country repository contract.
abstract interface class ICountryRepository {
  /// Provides information about all countries.
  Future<List<Country>> loadAllCountries();
}
