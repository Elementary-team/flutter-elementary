import 'package:json_annotation/json_annotation.dart';

part 'country_data.g.dart';

/// DTO for country.
@JsonSerializable()
class CountryData {
  final String name;
  final String capital;
  final String region;
  final String subregion;
  final String nativeName;
  final String alpha2Code;

  CountryData({
    required this.capital,
    required this.region,
    required this.subregion,
    required this.nativeName,
    required this.alpha2Code,
    required this.name,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) =>
      _$CountryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDataToJson(this);
}
