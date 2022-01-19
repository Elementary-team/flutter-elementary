import 'package:elementary/elementary.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/full_name_screen/full_name_screen.dart';
import 'package:profile/features/profile/service/bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/bloc/profile_event.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';

/// Model for [FullNameScreen].
class FullNameScreenModel extends ElementaryModel {
  final ProfileBloc _profileBloc;

  /// Stream to track the state of the bloc.
  Stream<BaseProfileState> get profileStateStream => _profileBloc.stream;

  /// Gives the current state.
  BaseProfileState get currentState => _profileBloc.state;

  /// Create an instance [FullNameScreenModel].
  FullNameScreenModel(
    this._profileBloc,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  @override
  void init() {
    super.init();
    _profileBloc.add(ProfileLoadEvent());
  }

  /// Method for passing new data to the [ProfileBloc].
  void saveFullName(
    String surname,
    String name,
    String? patronymic,
    DateTime birthday,
  ) {
    final newProfile = Profile(
      surname: surname,
      name: name,
      patronymic: patronymic,
      birthday: birthday,
    );
    _profileBloc.add(SaveFullNameEvent(newProfile));
  }

  /// Callback on BackButton tap.
  void backButtonTap() {
    _profileBloc.add(UndoEditingEvent());
  }
}
