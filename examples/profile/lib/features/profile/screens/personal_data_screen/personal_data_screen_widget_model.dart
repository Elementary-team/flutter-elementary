import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/domain/entity/app_coordinate.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/personal_data_screen/personal_data_screen.dart';
import 'package:profile/features/profile/screens/personal_data_screen/personal_data_screen_model.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';
import 'package:provider/provider.dart';

/// Factory for [PersonalDataScreenWidgetModel].
PersonalDataScreenWidgetModel fullNameScreenWidgetModelFactory(
  BuildContext context,
) {
  final appDependencies = context.read<IAppScope>();
  final model = PersonalDataScreenModel(
    appDependencies.profileBloc,
    appDependencies.errorHandler,
  );
  final coordinator = context.read<IAppScope>().coordinator;
  return PersonalDataScreenWidgetModel(
    model: model,
    coordinator: coordinator,
  );
}

/// Widget Model for [PersonalDataScreen].
class PersonalDataScreenWidgetModel
    extends WidgetModel<PersonalDataScreen, PersonalDataScreenModel>
    implements IPersonalDataWidgetModel {
  /// Coordinator for navigation.
  final Coordinator coordinator;

  final _surnameFormKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();
  final _birthdayFormKey = GlobalKey<FormState>();

  final _birthdayEditingController = TextEditingController();
  final _profileEntityState = EntityStateNotifier<Profile>();
  late final StreamSubscription<BaseProfileState> _stateStatusStream;

  @override
  GlobalKey<FormState> get surnameFormKey => _surnameFormKey;

  @override
  GlobalKey<FormState> get nameFormKey => _nameFormKey;

  @override
  GlobalKey<FormState> get birthdayFormKey => _birthdayFormKey;

  @override
  ListenableState<EntityState<Profile>> get profileEntityState =>
      _profileEntityState;

  @override
  TextEditingController get birthdayEditingController =>
      _birthdayEditingController;

  String? _currentSurname;
  String? _currentName;
  String? _currentPatronymic;
  DateTime? _currentBirthday;

  /// Create an instance [PersonalDataScreenWidgetModel].
  PersonalDataScreenWidgetModel({
    required PersonalDataScreenModel model,
    required this.coordinator,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _stateStatusStream = model.profileStateStream.listen(_updateState);
    _initProfile();
  }

  @override
  void dispose() {
    _birthdayEditingController.dispose();
    _stateStatusStream.cancel();
    super.dispose();
  }

  @override
  void updateSurname(String? newValue) {
    surnameFormKey.currentState!.validate();
    _currentSurname = newValue;
  }

  @override
  void updateName(String? newValue) {
    nameFormKey.currentState!.validate();
    _currentName = newValue;
  }

  @override
  void updatePatronymic(String? newValue) {
    _currentPatronymic = newValue;
  }

  @override
  void savePersonalData() {
    if (surnameFormKey.currentState!.validate() &
        nameFormKey.currentState!.validate() &
        birthdayFormKey.currentState!.validate()) {
      if (_currentSurname != null &&
          _currentName != null &&
          _currentBirthday != null) {
        model.saveFullName(
          _currentSurname!,
          _currentName!,
          _currentPatronymic,
          _currentBirthday!,
        );
      }
      coordinator.navigate(context, AppCoordinate.placeResidenceScreen);
    }
  }

  @override
  Future<void> onDateTap(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (date != null) {
      _currentBirthday = date;
      _birthdayEditingController.text = _getDateToString(date);
      birthdayFormKey.currentState!.validate();
    }
  }

  @override
  void backButtonTap() {
    model.backButtonTap();
    coordinator.pop();
  }

  void _initProfile() {
    final state = model.currentState;
    if (state is InitProfileState) {
      _profileEntityState.loading();
    } else if (state is ProfileState) {
      final profile = state.profile;
      _profileEntityState.content(profile);
      if (profile.birthday != null) {
        _birthdayEditingController.text = _getDateToString(profile.birthday!);
      }
      _currentSurname = profile.surname;
      _currentName = profile.name;
      _currentPatronymic = profile.patronymic;
      _currentBirthday = profile.birthday;
    } else if (state is ErrorLoadingState) {
      _profileEntityState.error();
    }
  }

  void _updateState(BaseProfileState state) {
    if (state is InitProfileState) {
      _profileEntityState.loading();
    } else if (state is ProfileState || state is PendingProfileState) {
      final profile = (state as ProfileState).profile;
      _profileEntityState.content(profile);
    } else if (state is ErrorLoadingState) {
      _profileEntityState.error();
    }
  }

  String _getDateToString(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}

/// Interface of [PersonalDataScreenWidgetModel].
abstract class IPersonalDataWidgetModel extends IWidgetModel {
  /// Validation form key for surname.
  GlobalKey<FormState> get surnameFormKey;

  /// Validation form key for name.
  GlobalKey<FormState> get nameFormKey;

  /// Validation form key for birthday.
  GlobalKey<FormState> get birthdayFormKey;

  /// Text Editing Controller for birthday.
  TextEditingController get birthdayEditingController;

  /// State of state.
  ListenableState<EntityState<Profile>> get profileEntityState;

  /// Function to change surname.
  void updateSurname(String? newValue) {}

  /// Function to change name.
  void updateName(String? newValue) {}

  /// Function to change second name.
  void updatePatronymic(String? newValue) {}

  /// Function to open DatePicker.
  Future<void> onDateTap(BuildContext context) async {}

  /// Function to save new [Profile].
  void savePersonalData() {}

  /// Callback on BackButton tap.
  void backButtonTap() {}
}
