// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DogDTO _$DogDTOFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DogDTO',
      json,
      ($checkedConvert) {
        final val = DogDTO(
          $checkedConvert('message', (v) => v as String),
          $checkedConvert('status', (v) => v as String),
        );
        return val;
      },
    );
