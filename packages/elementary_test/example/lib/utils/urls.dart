/// Util class with all app urls.
class AppUrls {
  static const all = '$_apiUrl/all';

  static const String _apiUrl = 'https://restcountries.eu/rest/v2';

  static String getFlagByCode(String code) =>
      'https://flagcdn.com/w640/$code.jpg';
}
