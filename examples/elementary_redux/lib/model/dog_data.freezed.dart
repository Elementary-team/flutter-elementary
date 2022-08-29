// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'dog_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DogData {
  String get message => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DogDataCopyWith<DogData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DogDataCopyWith<$Res> {
  factory $DogDataCopyWith(DogData value, $Res Function(DogData) then) =
      _$DogDataCopyWithImpl<$Res>;
  $Res call({String message, String status});
}

/// @nodoc
class _$DogDataCopyWithImpl<$Res> implements $DogDataCopyWith<$Res> {
  _$DogDataCopyWithImpl(this._value, this._then);

  final DogData _value;
  // ignore: unused_field
  final $Res Function(DogData) _then;

  @override
  $Res call({
    Object? message = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_DogDataCopyWith<$Res> implements $DogDataCopyWith<$Res> {
  factory _$$_DogDataCopyWith(
          _$_DogData value, $Res Function(_$_DogData) then) =
      __$$_DogDataCopyWithImpl<$Res>;
  @override
  $Res call({String message, String status});
}

/// @nodoc
class __$$_DogDataCopyWithImpl<$Res> extends _$DogDataCopyWithImpl<$Res>
    implements _$$_DogDataCopyWith<$Res> {
  __$$_DogDataCopyWithImpl(_$_DogData _value, $Res Function(_$_DogData) _then)
      : super(_value, (v) => _then(v as _$_DogData));

  @override
  _$_DogData get _value => super._value as _$_DogData;

  @override
  $Res call({
    Object? message = freezed,
    Object? status = freezed,
  }) {
    return _then(_$_DogData(
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_DogData implements _DogData {
  const _$_DogData({required this.message, required this.status});

  @override
  final String message;
  @override
  final String status;

  @override
  String toString() {
    return 'DogData(message: $message, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DogData &&
            const DeepCollectionEquality().equals(other.message, message) &&
            const DeepCollectionEquality().equals(other.status, status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(message),
      const DeepCollectionEquality().hash(status));

  @JsonKey(ignore: true)
  @override
  _$$_DogDataCopyWith<_$_DogData> get copyWith =>
      __$$_DogDataCopyWithImpl<_$_DogData>(this, _$identity);
}

abstract class _DogData implements DogData {
  const factory _DogData(
      {required final String message,
      required final String status}) = _$_DogData;

  @override
  String get message => throw _privateConstructorUsedError;
  @override
  String get status => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_DogDataCopyWith<_$_DogData> get copyWith =>
      throw _privateConstructorUsedError;
}
