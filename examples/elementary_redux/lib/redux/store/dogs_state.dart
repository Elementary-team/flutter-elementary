import 'package:dio/dio.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/dog_data.dart';

part 'dogs_state.freezed.dart';

@freezed
class DogsState with _$DogsState {
  const factory DogsState({
    @Default(IListConst<DogData>([])) IList<DogData> dogsList,
    @Default(null) DioError? error,
  }) = _DogsState;
}
