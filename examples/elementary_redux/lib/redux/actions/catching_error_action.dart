import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

@immutable
class CatchingErrorAction {
  final DioError error;

  const CatchingErrorAction(this.error);
}
