import 'package:elementary/elementary.dart';
import 'package:profile/features/profile/screens/personal_data_screen/personal_data_screen.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_event.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_state.dart';

/// Model for [PersonalDataScreen].
class PersonalDataScreenModel extends ElementaryModel {
  final ProfileBloc _profileBloc;

  /// Stream to track the state of the profile_bloc.
  Stream<BaseProfileState> get profileStateStream => _profileBloc.stream;

  /// Gives the current state.
  BaseProfileState get currentState => _profileBloc.state;

  /// Create an instance [PersonalDataScreenModel].
  PersonalDataScreenModel(
    this._profileBloc,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  @override
  void init() {
    super.init();
    _profileBloc.add(ProfileLoadEvent());
  }

  /// Method for passing new data to the [ProfileBloc].
  void updatePersonalData(
    String surname,
    String name,
    String? patronymic,
    DateTime birthday,
  ) {
    _profileBloc.add(
      UpdatePersonalDataEvent(
        surname: surname,
        name: name,
        patronymic: patronymic,
        birthday: birthday,
      ),
    );
  }

  /// Callback on BackButton tap.
  void backButtonTap() {
    _profileBloc.add(CancelEditingEvent());
  }
}
