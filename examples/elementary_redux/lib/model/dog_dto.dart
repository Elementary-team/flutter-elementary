import 'package:json_annotation/json_annotation.dart';

import 'dog_data.dart';

part 'dog_dto.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class DogDTO {
  final String message;
  final String status;

  const DogDTO(
    this.message,
    this.status,
  );

  factory DogDTO.fromJson(Map<String, dynamic> json) => _$DogDTOFromJson(json);

  DogData toModel() => DogData(
        message: message,
        status: status,
      );
}
