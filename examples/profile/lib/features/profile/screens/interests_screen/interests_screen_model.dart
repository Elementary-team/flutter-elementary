import 'package:elementary/elementary.dart';
import 'package:profile/features/interests/service/repository/mock_interests_repository.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_event.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_state.dart';

/// Model for [InterestsScreen].
class InterestsScreenModel extends ElementaryModel {
  /// Bloc for working with profile states.
  final ProfileBloc _profileBloc;

  final IInterestsRepository _repository;

  /// Gives the current state.
  BaseProfileState get currentState => _profileBloc.state;

  /// Create an instance [InterestsScreenModel].
  InterestsScreenModel(
    this._profileBloc,
    this._repository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  /// Return list with interests from [IInterestsRepository].
  Future<List<String>> getInterestsList() async {
    return _repository.getListInterests();
  }

  /// Method for update list interests.
  void updateInterests(List<String>? interests) {
    _profileBloc.add(UpdateInterestsEvent(interests: interests));
  }
}
