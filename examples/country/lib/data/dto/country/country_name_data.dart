import 'package:json_annotation/json_annotation.dart';

part 'country_name_data.g.dart';

/// DTO for country.
@JsonSerializable()
class CountryNameData {
  final String common;
  final String official;

  CountryNameData({
    required this.common,
    required this.official,
  });

  factory CountryNameData.fromJson(Map<String, dynamic> json) =>
      _$CountryNameDataFromJson(json);

  Map<String, dynamic> toJson() => _$CountryNameDataToJson(this);
}