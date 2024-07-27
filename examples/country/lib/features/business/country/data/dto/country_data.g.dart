// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryData _$CountryDataFromJson(Map<String, dynamic> json) => CountryData(
      name: CountryNameData.fromJson(json['name'] as Map<String, dynamic>),
      flags: CountryFlagData.fromJson(json['flags'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CountryDataToJson(CountryData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'flags': instance.flags,
    };
