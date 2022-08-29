import 'package:freezed_annotation/freezed_annotation.dart';

part 'dog_data.freezed.dart';

@freezed
class DogData with _$DogData {
  const factory DogData({
    required final String message,
    required final String status,
  }) = _DogData;
}
