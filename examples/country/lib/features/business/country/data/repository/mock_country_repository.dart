import 'dart:convert';

import 'package:country/features/business/country/data/converter/country_mappers.dart';
import 'package:country/features/business/country/data/dto/country_data.dart';
import 'package:country/features/business/country/domain/contract/country_repository.dart';
import 'package:country/features/business/country/domain/model/country.dart';
import 'package:flutter/services.dart';

/// A mock implementation of [ICountryRepository] that uses local dummy data
/// from json file.
class MockCountryRepository implements ICountryRepository {
  MockCountryRepository();

  @override
  Future<List<Country>> loadAllCountries() async {
    final countriesJson =
        await rootBundle.loadString('assets/mock_data/countries.json');
    final listData = (jsonDecode(countriesJson) as List<dynamic>).map(
      // ignore: avoid_annotating_with_dynamic
      (dynamic i) => CountryData.fromJson(i as Map<String, dynamic>),
    );

    return listData.map(mapCountry).toList();
  }
}
