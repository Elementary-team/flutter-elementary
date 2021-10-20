import 'package:country/data/dto/country/country_data.dart';
import 'package:country/domain/country/country.dart';

/// Map Country from CountryData
Country mapCountry(CountryData data) {
  return Country(
    name: data.name.common,
    flag: data.flags.png.replaceFirst('/w320/', '/w640/'),
  );
}
