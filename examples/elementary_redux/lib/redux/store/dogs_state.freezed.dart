// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'dogs_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DogsState {
  IList<DogData> get dogsList => throw _privateConstructorUsedError;
  DioError? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DogsStateCopyWith<DogsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DogsStateCopyWith<$Res> {
  factory $DogsStateCopyWith(DogsState value, $Res Function(DogsState) then) =
      _$DogsStateCopyWithImpl<$Res>;
  $Res call({IList<DogData> dogsList, DioError? error});
}

/// @nodoc
class _$DogsStateCopyWithImpl<$Res> implements $DogsStateCopyWith<$Res> {
  _$DogsStateCopyWithImpl(this._value, this._then);

  final DogsState _value;
  // ignore: unused_field
  final $Res Function(DogsState) _then;

  @override
  $Res call({
    Object? dogsList = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      dogsList: dogsList == freezed
          ? _value.dogsList
          : dogsList // ignore: cast_nullable_to_non_nullable
              as IList<DogData>,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as DioError?,
    ));
  }
}

/// @nodoc
abstract class _$$_DogsStateCopyWith<$Res> implements $DogsStateCopyWith<$Res> {
  factory _$$_DogsStateCopyWith(
          _$_DogsState value, $Res Function(_$_DogsState) then) =
      __$$_DogsStateCopyWithImpl<$Res>;
  @override
  $Res call({IList<DogData> dogsList, DioError? error});
}

/// @nodoc
class __$$_DogsStateCopyWithImpl<$Res> extends _$DogsStateCopyWithImpl<$Res>
    implements _$$_DogsStateCopyWith<$Res> {
  __$$_DogsStateCopyWithImpl(
      _$_DogsState _value, $Res Function(_$_DogsState) _then)
      : super(_value, (v) => _then(v as _$_DogsState));

  @override
  _$_DogsState get _value => super._value as _$_DogsState;

  @override
  $Res call({
    Object? dogsList = freezed,
    Object? error = freezed,
  }) {
    return _then(_$_DogsState(
      dogsList: dogsList == freezed
          ? _value.dogsList
          : dogsList // ignore: cast_nullable_to_non_nullable
              as IList<DogData>,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as DioError?,
    ));
  }
}

/// @nodoc

class _$_DogsState implements _DogsState {
  const _$_DogsState(
      {this.dogsList = const IListConst<DogData>([]), this.error = null});

  @override
  @JsonKey()
  final IList<DogData> dogsList;
  @override
  @JsonKey()
  final DioError? error;

  @override
  String toString() {
    return 'DogsState(dogsList: $dogsList, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DogsState &&
            const DeepCollectionEquality().equals(other.dogsList, dogsList) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(dogsList),
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  _$$_DogsStateCopyWith<_$_DogsState> get copyWith =>
      __$$_DogsStateCopyWithImpl<_$_DogsState>(this, _$identity);
}

abstract class _DogsState implements DogsState {
  const factory _DogsState(
      {final IList<DogData> dogsList, final DioError? error}) = _$_DogsState;

  @override
  IList<DogData> get dogsList => throw _privateConstructorUsedError;
  @override
  DioError? get error => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_DogsStateCopyWith<_$_DogsState> get copyWith =>
      throw _privateConstructorUsedError;
}
