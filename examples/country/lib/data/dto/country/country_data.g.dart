// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryData _$CountryDataFromJson(Map<String, dynamic> json) {
  return CountryData(
    capital: json['capital'] as String,
    region: json['region'] as String,
    subregion: json['subregion'] as String,
    nativeName: json['nativeName'] as String,
    alpha2Code: json['alpha2Code'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$CountryDataToJson(CountryData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'capital': instance.capital,
      'region': instance.region,
      'subregion': instance.subregion,
      'nativeName': instance.nativeName,
      'alpha2Code': instance.alpha2Code,
    };
