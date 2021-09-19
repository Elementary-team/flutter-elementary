import 'package:country/data/dto/country/country_data.dart';
import 'package:country/domain/country/country.dart';
import 'package:country/utils/urls.dart';

/// Map Country from CountryData
Country mapCountry(CountryData data) {
  return Country(
    capital: data.capital,
    region: data.region,
    subregion: data.subregion,
    nativeName: data.nativeName,
    flag: AppUrls.getFlagByCode(data.alpha2Code.toLowerCase()),
    name: data.name,
  );
}
