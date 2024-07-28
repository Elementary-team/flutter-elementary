import 'package:country/features/business/country/data/api/country_client.dart';
import 'package:country/features/business/country/data/converter/country_mappers.dart';
import 'package:country/features/business/country/domain/contract/country_repository.dart';
import 'package:country/features/business/country/domain/model/country.dart';

/// An implementation of [ICountryRepository] uses http requests to get data.
class CountryRepository implements ICountryRepository {
  final CountryClient _client;

  /// Creates an instance of [CountryRepository].
  CountryRepository(this._client);

  @override
  Future<List<Country>> loadAllCountries() async {
    final data = await _client.getAll();
    return data.map(mapCountry).toList();
  }
}
