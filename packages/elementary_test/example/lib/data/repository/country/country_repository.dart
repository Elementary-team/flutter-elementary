import 'package:country/data/api/country/country_client.dart';
import 'package:country/data/repository/country/country_mappers.dart';
import 'package:country/domain/country/country.dart';

/// Country repository
class CountryRepository {
  final CountryClient _client;

  CountryRepository(this._client);

  /// Return all countries
  Future<Iterable<Country>> getAllCountries() => _client.getAll().then(
        (value) => value.map(mapCountry),
      );
}
