import 'package:country/config/urls.dart';
import 'package:country/features/business/country/data/api/country_client.dart';
import 'package:country/features/business/country/data/repository/country_repository.dart';
import 'package:country/features/business/country/data/repository/mock_country_repository.dart';
import 'package:country/features/business/country/domain/contract/country_repository.dart';
import 'package:country/features/presentation/routing/app_coordinates.dart';
import 'package:country/features/presentation/routing/coordinator.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen_model.dart';
import 'package:country/features/presentation/screens/country_list_screen/country_list_screen_widget_model.dart';
import 'package:country/utils/wrappers/scaffold_messenger_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:elementary/elementary.dart';

/// Scope of dependencies which need through all app's lifecycle.
class AppScope implements IAppScope {
  late final Dio _dio;
  late final Coordinator _coordinator;
  late final ErrorHandler _errorHandler;
  late final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  late final _countryRepository = _countryRepositoryFactory();

  @override
  Coordinator get coordinator => _coordinator;

  /// Create an instance of [AppScope].
  AppScope() {
    _dio = _initDio();
    _coordinator = Coordinator();
    _coordinator.init(appCoordinates, AppCoordinate.initial);
    _errorHandler = DefaultDebugErrorHandler();
    _scaffoldMessengerWrapper = ScaffoldMessengerWrapper();
  }

  Dio _initDio() {
    const timeout = Duration(seconds: 30);

    final dio = Dio();

    dio.options
      ..baseUrl = AppUrls.base
      ..connectTimeout = timeout
      ..receiveTimeout = timeout
      ..sendTimeout = timeout;

    return dio;
  }

  @override
  CountryListScreenWidgetModel createCountryListScreenWidgetModel() {
    return CountryListScreenWidgetModel(
      _createCountryListScreenModel(),
      _scaffoldMessengerWrapper,
    );
  }

  CountryListScreenModel _createCountryListScreenModel() {
    return CountryListScreenModel(
      _countryRepository,
      _errorHandler,
    );
  }

  ICountryRepository _countryRepositoryFactory() {
    // ignore: do_not_use_environment
    const isMock = bool.fromEnvironment('useMock');

    return isMock
        ? _mockCountryRepositoryFactory()
        : _httpCountryRepositoryFactory();
  }

  MockCountryRepository _mockCountryRepositoryFactory() {
    return MockCountryRepository();
  }

  CountryRepository _httpCountryRepositoryFactory() {
    return CountryRepository(_countryClientFactory());
  }

  CountryClient _countryClientFactory() {
    return CountryClient(
      _dio,
    );
  }
}

/// App dependencies.
abstract class IAppScope {
  /// Navigation manager.
  Coordinator get coordinator;

  /// Factory for creating [CountryListScreenWidgetModel].
  CountryListScreenWidgetModel createCountryListScreenWidgetModel();
}
