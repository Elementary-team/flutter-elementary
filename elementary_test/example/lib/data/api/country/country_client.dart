import 'package:country/data/dto/country/country_data.dart';
import 'package:country/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'country_client.g.dart';

@RestApi()
abstract class CountryClient {
  factory CountryClient(Dio dio, {String baseUrl}) = _CountryClient;

  /// Получение списка адресов пользователя
  @GET(AppUrls.all)
  Future<List<CountryData>> getAll();
}
