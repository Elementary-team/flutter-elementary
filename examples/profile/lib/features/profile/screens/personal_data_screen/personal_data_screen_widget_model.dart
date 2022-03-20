import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/domain/entity/app_coordinate.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/personal_data_screen/personal_data_screen.dart';
import 'package:profile/features/profile/screens/personal_data_screen/personal_data_screen_model.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_state.dart';
import 'package:profile/util/dialog_controller.dart';
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
  final coordinator = appDependencies.coordinator;
  final dialogController = appDependencies.dialogController;
  return PersonalDataScreenWidgetModel(
    model: model,
    coordinator: coordinator,
    dialogController: dialogController,
  );
}

/// Widget Model for [PersonalDataScreen].
class PersonalDataScreenWidgetModel
    extends WidgetModel<PersonalDataScreen, PersonalDataScreenModel>
    implements IPersonalDataWidgetModel {
  /// Coordinator for navigation.
  final Coordinator coordinator;

  /// Controller to show [DatePickerDialog].
  final DialogController dialogController;

  final _formKey = GlobalKey<FormState>();

  final _surnameEditingController = TextEditingController();
  final _nameEditingController = TextEditingController();
  final _secondNameEditingController = TextEditingController();
  final _birthdayEditingController = TextEditingController();
  final _profileEntityState = EntityStateNotifier<Profile>();
  late final StreamSubscription<BaseProfileState> _stateStatusSubscription;

  @override
  GlobalKey<FormState> get formKey => _formKey;

  @override
  ListenableState<EntityState<Profile>> get profileEntityState =>
      _profileEntityState;

  @override
  TextEditingController get surnameEditingController =>
      _surnameEditingController;

  @override
  TextEditingController get nameEditingController => _nameEditingController;

  @override
  TextEditingController get secondNameEditingController =>
      _secondNameEditingController;

  @override
  TextEditingController get birthdayEditingController =>
      _birthdayEditingController;

  /// Create an instance [PersonalDataScreenWidgetModel].
  PersonalDataScreenWidgetModel({
    required PersonalDataScreenModel model,
    required this.coordinator,
    required this.dialogController,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _stateStatusSubscription = model.profileStateStream.listen(_updateState);
    _updateState(model.currentState);
  }

  @override
  void dispose() {
    _surnameEditingController.dispose();
    _nameEditingController.dispose();
    _secondNameEditingController.dispose();
    _birthdayEditingController.dispose();
    _stateStatusSubscription.cancel();
    _profileEntityState.dispose();
    super.dispose();
  }

  @override
  void updatePersonalData() {
    if (formKey.currentState!.validate()) {
      model.updatePersonalData(
        _surnameEditingController.text,
        _nameEditingController.text,
        _secondNameEditingController.text,
        DateTime.parse(_birthdayEditingController.text),
      );
      coordinator.navigate(context, AppCoordinates.placeResidenceScreen);
    }
  }

  @override
  Future<void> onDateTap(BuildContext context) async {
    final date = await dialogController.showPicker(context);
    if (date != null) {
      _birthdayEditingController.text = _getDateToString(date);
    }
  }

  @override
  void backButtonTap() {
    model.backButtonTap();
    coordinator.pop();
  }

  @override
  String? surnameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field must be filled';
    } else {
      return null;
    }
  }

  @override
  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field must be filled';
    } else if (value.length < 2) {
      return 'The name cannot contain less than two characters';
    } else {
      return null;
    }
  }

  @override
  String? birthdayValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field must be filled';
    } else {
      return null;
    }
  }

  void _updateState(BaseProfileState state) {
    if (state is InitProfileState) {
      _profileEntityState.loading();
    } else if (state is ProfileState) {
      final profile = state.profile;
      _profileEntityState.content(profile);
      _initField(profile);
    } else if (state is ErrorProfileLoadingState) {
      _profileEntityState.error();
    }
  }

  void _initField(Profile profile) {
    if (profile.birthday != null) {
      _birthdayEditingController.text = _getDateToString(profile.birthday!);
    }
    if (profile.surname != null) {
      _surnameEditingController.text = profile.surname!;
    }
    if (profile.name != null) {
      _nameEditingController.text = profile.name!;
    }
    if (profile.secondName != null) {
      _secondNameEditingController.text = profile.secondName!;
    }
  }

  String _getDateToString(DateTime date) {
    final month = _twoDigits(date.month);
    final day = _twoDigits(date.day);
    return '${date.year}-$month-$day';
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}

/// Interface of [PersonalDataScreenWidgetModel].
abstract class IPersonalDataWidgetModel extends IWidgetModel {
  /// Validation form key for surname.
  GlobalKey<FormState> get formKey;

  /// Text Editing Controller for surname.
  TextEditingController get surnameEditingController;

  /// Text Editing Controller for name.
  TextEditingController get nameEditingController;

  /// Text Editing Controller for secondName.
  TextEditingController get secondNameEditingController;

  /// Text Editing Controller for birthday.
  TextEditingController get birthdayEditingController;

  /// State of state.
  ListenableState<EntityState<Profile>> get profileEntityState;

  /// Function to open DatePicker.
  Future<void> onDateTap(BuildContext context);

  /// Function to save new [Profile].
  void updatePersonalData();

  /// Callback on BackButton tap.
  void backButtonTap();

  /// Validator for surname field.
  String? surnameValidator(String? value);

  /// Validator for name field.
  String? nameValidator(String? value);

  /// Validator for birthday field.
  String? birthdayValidator(String? value);
}
