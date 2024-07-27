import 'package:country/features/business/country/domain/contract/country_repository.dart';
import 'package:elementary/elementary.dart';
import 'package:mocktail/mocktail.dart';

class CountryRepositoryMock extends Mock implements ICountryRepository {}

class ErrorHandlerMock extends Mock implements ErrorHandler {}
