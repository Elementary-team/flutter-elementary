import 'package:dio/dio.dart';

import '../model/dog_dto.dart';

class Client {
  final Dio _dio;

  const Client(this._dio);

  static const baseUrl = 'https://dog.ceo/api/breeds/image/random';

  Future<DogDTO?> getDog() async {
    final response = await _dio.get<Map<String, dynamic>>(baseUrl);

    if (response.data != null) {
      return DogDTO.fromJson(response.data!);
    }

    return null;
  }
}
