import 'package:country/data/dto/country/country_flag_data.dart';
import 'package:country/data/dto/country/country_name_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country_data.g.dart';

/// DTO for country.
@JsonSerializable()
class CountryData {
  final CountryNameData name;
  final CountryFlagData flags;

  CountryData({
    required this.name,
    required this.flags,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) =>
      _$CountryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDataToJson(this);
}