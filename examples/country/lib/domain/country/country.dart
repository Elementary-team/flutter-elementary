/// Country model.
class Country {
  final String name;
  final String capital;
  final String region;
  final String subregion;
  final String nativeName;
  final String flag;

  Country({
    required this.capital,
    required this.region,
    required this.subregion,
    required this.nativeName,
    required this.flag,
    required this.name,
  });
}
