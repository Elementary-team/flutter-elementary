import 'package:country/config/urls.dart';
import 'package:country/features/business/country/data/dto/country_data.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'country_client.g.dart';

@RestApi()
abstract class CountryClient {
  factory CountryClient(Dio dio, {String baseUrl}) = _CountryClient;

  /// An endpoint provides country list.
  @GET(AppUrls.allCountries)
  Future<List<CountryData>> getAll();
}
