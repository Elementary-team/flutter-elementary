import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/common/dialog_controller.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/service/bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/mock_server/mock_server.dart';
import 'package:profile/features/profile/service/repository/mock_cities_repository.dart';
import 'package:profile/features/profile/service/repository/mock_interests_repository.dart';
import 'package:profile/features/profile/service/repository/mock_profile_repository.dart';
import 'package:profile/util/default_error_handler.dart';

/// Scope of dependencies which need through all app's life.
class AppScope implements IAppScope {
  late final ErrorHandler _errorHandler;
  late final Coordinator _coordinator;
  late final ProfileBloc _profileBloc;
  late final MockCitiesRepository _mockCitiesRepository;
  late final MockInterestsRepository _mockInterestsRepository;
  late final DialogController _dialogController;

  @override
  ErrorHandler get errorHandler => _errorHandler;

  @override
  Coordinator get coordinator => _coordinator;

  @override
  ProfileBloc get profileBloc => _profileBloc;

  @override
  MockCitiesRepository get mockCitiesRepository => _mockCitiesRepository;

  @override
  MockInterestsRepository get mockInterestsRepository =>
      _mockInterestsRepository;

  @override
  DialogController get dialogController => _dialogController;

  /// Create an instance [AppScope].
  AppScope() {
    _errorHandler = DefaultErrorHandler();
    _coordinator = Coordinator();
    final mockServer = MockServer();
    _mockCitiesRepository = MockCitiesRepository(mockServer);
    _mockInterestsRepository = MockInterestsRepository(mockServer);
    _profileBloc = ProfileBloc(MockProfileRepository(mockServer));
    _dialogController = const DialogController();
  }
}

/// App dependencies.
abstract class IAppScope {
  /// Interface for handle error in business logic.
  ErrorHandler get errorHandler;

  /// Class that coordinates navigation for the whole app.
  Coordinator get coordinator;

  /// Bloc for working with profile states.
  ProfileBloc get profileBloc;

  /// Mock repository to work with cities.
  MockCitiesRepository get mockCitiesRepository;

  /// Mock repository to work with interests.
  MockInterestsRepository get mockInterestsRepository;

  /// Message controller for show [SnackBar].
  DialogController get dialogController;
}
