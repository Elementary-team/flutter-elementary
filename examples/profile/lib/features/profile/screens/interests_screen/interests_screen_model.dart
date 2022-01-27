import 'package:elementary/elementary.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen.dart';
import 'package:profile/features/profile/service/bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/bloc/profile_event.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';
import 'package:profile/features/profile/service/repository/mock_interests_repository.dart';

/// Model for [InterestsScreen].
class InterestsScreenModel extends ElementaryModel {
  /// Bloc for working with profile states.
  final ProfileBloc _profileBloc;

  final MockInterestsRepository _repository;

  /// Gives the current state.
  BaseProfileState get currentState => _profileBloc.state;

  /// Create an instance [InterestsScreenModel].
  InterestsScreenModel(
    this._profileBloc,
    this._repository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  /// Return list with interests from [MockInterestsRepository].
  List<String> getMockInterestsList() {
    return _repository.getMockListInterests();
  }

  /// Method for save list interests.
  void saveListInterests(List<String>? interests) {
    _profileBloc.add(SaveInterestsEvent(interests: interests));
  }
}
