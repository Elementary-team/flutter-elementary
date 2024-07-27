import 'package:country/features/business/country/data/dto/country_data.dart';
import 'package:country/features/business/country/domain/model/country.dart';

/// Map Country from CountryData
Country mapCountry(CountryData data) {
  return Country(
    name: data.name.common,
    flag: data.flags.png.replaceFirst('/w320/', '/w640/'),
  );
}
