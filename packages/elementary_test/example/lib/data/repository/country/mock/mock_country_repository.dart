import 'dart:convert';

import 'package:country/data/dto/country/country_data.dart';
import 'package:country/data/repository/country/country_mappers.dart';
import 'package:country/data/repository/country/country_repository.dart';
import 'package:country/domain/country/country.dart';
import 'package:flutter/services.dart';

/// Country repository, for emulate backend if api die.
class MockCountryRepository implements CountryRepository {
  MockCountryRepository();

  /// Return all countries
  @override
  Future<Iterable<Country>> getAllCountries() async {
    final countriesJson =
        await rootBundle.loadString('assets/mock_data/countries.json');
    final listData = (jsonDecode(countriesJson) as List<dynamic>)
        .map(
          // ignore: avoid_annotating_with_dynamic
          (dynamic i) => CountryData.fromJson(i as Map<String, dynamic>),
        );

    return listData.map(mapCountry);
  }
}
