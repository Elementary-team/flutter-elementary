import 'package:json_annotation/json_annotation.dart';

part 'country_flag_data.g.dart';

/// DTO for country.
@JsonSerializable()
class CountryFlagData {
  final String png;
  final String svg;

  CountryFlagData({
    required this.png,
    required this.svg,
  });

  factory CountryFlagData.fromJson(Map<String, dynamic> json) =>
      _$CountryFlagDataFromJson(json);

  Map<String, dynamic> toJson() => _$CountryFlagDataToJson(this);
}