import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/domain/entity/app_coordinate.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/full_name_screen/full_name_screen.dart'
    show FullNameScreen;
import 'package:profile/features/profile/screens/full_name_screen/full_name_screen_model.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';
import 'package:provider/provider.dart';

/// Factory for [FullNameScreenWidgetModel].
FullNameScreenWidgetModel fullNameScreenWidgetModelFactory(
  BuildContext context,
) {
  final appDependencies = context.read<IAppScope>();
  final model = FullNameScreenModel(
    appDependencies.profileBloc,
    appDependencies.errorHandler,
  );
  return FullNameScreenWidgetModel(model);
}

/// Widget Model for [FullNameScreen].
class FullNameScreenWidgetModel
    extends WidgetModel<FullNameScreen, FullNameScreenModel>
    implements IFullNameWidgetModel {
  @override
  late final GlobalKey<FormState> surnameFormKey;

  @override
  late final GlobalKey<FormState> nameFormKey;

  @override
  late final GlobalKey<FormState> birthdayFormKey;

  late final Coordinator _coordinator;

  final _surnameEditingController = TextEditingController();
  final _nameEditingController = TextEditingController();
  final _patronymicEditingController = TextEditingController();
  final _birthdayEditingController = TextEditingController();
  final _profileEntityState = EntityStateNotifier<Profile>();

  late final StreamSubscription<BaseProfileState> _stateStatusStream;

  /// Current Birthday.
  @override
  DateTime? currentBirthday;

  @override
  ListenableState<EntityState<Profile>> get profileEntityState =>
      _profileEntityState;

  @override
  TextEditingController get surnameEditingController =>
      _surnameEditingController;

  @override
  TextEditingController get nameEditingController => _nameEditingController;

  @override
  TextEditingController get patronymicEditingController =>
      _patronymicEditingController;

  @override
  TextEditingController get birthdayEditingController =>
      _birthdayEditingController;

  String? _currentSurname;
  String? _currentName;
  String? _currentPatronymic;

  /// Create an instance [FullNameScreenWidgetModel].
  FullNameScreenWidgetModel(
    FullNameScreenModel model,
  ) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    _stateStatusStream = model.profileStateStream.listen(_updateState);

    surnameFormKey = GlobalKey<FormState>();
    nameFormKey = GlobalKey<FormState>();
    birthdayFormKey = GlobalKey<FormState>();

    _coordinator = context.read<IAppScope>().coordinator;
    _initProfile();
  }

  @override
  void dispose() {
    _birthdayEditingController.dispose();
    _surnameEditingController.dispose();
    _nameEditingController.dispose();
    _patronymicEditingController.dispose();

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
  void saveFullName() {
    if (surnameFormKey.currentState!.validate() &
        nameFormKey.currentState!.validate() &
        birthdayFormKey.currentState!.validate()) {
      if (_currentSurname != null &&
          _currentName != null &&
          currentBirthday != null) {
        model.saveFullName(
          _currentSurname!,
          _currentName!,
          _currentPatronymic,
          currentBirthday!,
        );
        _coordinator.navigate(context, AppCoordinate.placeResidenceScreen);
      }
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
      currentBirthday = date;
      _birthdayEditingController.text = _getDateToString(date);
      birthdayFormKey.currentState!.validate();
    }
  }

  @override
  void backButtonTap() {
    model.backButtonTap();
    _coordinator.pop();
  }

  void _initProfile() {
    final state = model.currentState;
    if (state is ProfileState) {
      final profile = state.profile;
      if (profile.surname != null) {
        _surnameEditingController.text = profile.surname!;
      }
      if (profile.name != null) {
        _nameEditingController.text = profile.name!;
      }
      if (profile.patronymic != null) {
        _patronymicEditingController.text = profile.patronymic!;
      }
      if (profile.birthday != null) {
        final date = profile.birthday!;
        _birthdayEditingController.text = _getDateToString(date);
      }
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

/// Interface of [FullNameScreenWidgetModel].
abstract class IFullNameWidgetModel extends IWidgetModel {
  /// Validation form key for surname.
  late final GlobalKey<FormState> surnameFormKey;

  /// Validation form key for name.
  late final GlobalKey<FormState> nameFormKey;

  /// Validation form key for birthday.
  late final GlobalKey<FormState> birthdayFormKey;

  /// Birthday.
  DateTime? currentBirthday;

  /// Text Editing Controller for surname.
  TextEditingController get surnameEditingController;

  /// Text Editing Controller for name.
  TextEditingController get nameEditingController;

  /// Text Editing Controller for second name.
  TextEditingController get patronymicEditingController;

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
  void saveFullName() {}

  /// callback on BackButton tap.
  void backButtonTap() {}
}
