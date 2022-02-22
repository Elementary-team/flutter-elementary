import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/strings/about_me_screen_strings.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen_model.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_state.dart';
import 'package:profile/util/dialog_controller.dart';
import 'package:provider/provider.dart';

/// Factory for [AboutMeScreenWidgetModel].
AboutMeScreenWidgetModel aboutMeScreenWidgetModelFactory(
  BuildContext context,
) {
  final appDependencies = context.read<IAppScope>();
  final model = AboutMeScreenModel(
    appDependencies.profileBloc,
    appDependencies.errorHandler,
  );
  final coordinator = appDependencies.coordinator;
  final dialogController = appDependencies.dialogController;
  return AboutMeScreenWidgetModel(
    model: model,
    coordinator: coordinator,
    dialogController: dialogController,
  );
}

/// Widget Model for [AboutMeScreen].
class AboutMeScreenWidgetModel
    extends WidgetModel<AboutMeScreen, AboutMeScreenModel>
    implements IAboutMeScreenWidgetModel {
  /// Coordinator for navigation.
  final Coordinator coordinator;

  /// Controller for show [SnackBar].
  final DialogController dialogController;

  final _controller = TextEditingController();
  final _buttonState = StateNotifier<String>();
  final _saveEntityState = EntityStateNotifier<Profile>();
  final _focusNode = FocusNode();
  late final StreamSubscription<BaseProfileState> _stateStatusSubscription;

  @override
  FocusNode get focusNode => _focusNode;

  @override
  TextEditingController get controller => _controller;

  @override
  ListenableState<String> get buttonState => _buttonState;

  @override
  ListenableState<EntityState<Profile>> get saveEntityState => _saveEntityState;

  String? _initialInfo;

  /// Create an instance [AboutMeScreenWidgetModel].
  AboutMeScreenWidgetModel({
    required AboutMeScreenModel model,
    required this.coordinator,
    required this.dialogController,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _stateStatusSubscription = model.profileStateStream.listen(_updateState);
    _controller.addListener(_aboutMeTextChanged);
    _initAboutMeInfo();
    _initButtonState();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_aboutMeTextChanged)
      ..dispose();
    _stateStatusSubscription.cancel();
    _buttonState.dispose();
    _saveEntityState.dispose();
    super.dispose();
  }

  @override
  void updateAboutMe() {
    final currentState = model.currentState;
    if (currentState is ISaveAvailable) {
      focusNode.unfocus();
      model.saveProfile();
    } else {
      coordinator.popUntilRoot();
    }
  }

  void _aboutMeTextChanged() {
    if (_initialInfo != _controller.text) {
      _buttonState.accept(AboutMeScreenStrings.saveButtonTitle);
      model.updateAboutMe(_controller.text);
    } else {
      _buttonState.accept(AboutMeScreenStrings.okButtonTitle);
      model.cancelEditing();
    }
  }

  void _initAboutMeInfo() {
    final state = model.currentState;
    if (state is ProfileContentState) {
      final currentState = state as IEditingAvailable;
      final profile = currentState.profile;
      if (profile.aboutMe != null) {
        _controller.text = profile.aboutMe!;
        _initialInfo = profile.aboutMe;
      }
    }
  }

  void _initButtonState() {
    final currentState = model.currentState;
    if (currentState is PendingProfileState) {
      final initialProfile = currentState.initialProfile;
      final currentProfile = currentState.profile;
      if (currentProfile != initialProfile) {
        _buttonState.accept(AboutMeScreenStrings.saveButtonTitle);
      }
    } else {
      _buttonState.accept(AboutMeScreenStrings.okButtonTitle);
    }
  }

  void _updateState(BaseProfileState state) {
    if (state is ProfileState) {
      _saveEntityState.content(state.profile);
    } else if (state is ProfileSavedSuccessfullyState) {
      coordinator.popUntilRoot();
    } else if (state is SavingProfileState) {
      _saveEntityState.loading();
    } else if (state is ProfileSaveFailedState) {
      dialogController.showSnackBar(
        context,
        AboutMeScreenStrings.errorSnackBar,
      );
      _saveEntityState.content(state.profile);
    }
  }
}

/// Interface of [AboutMeScreenWidgetModel].
abstract class IAboutMeScreenWidgetModel extends IWidgetModel {
  /// Focus node.
  FocusNode get focusNode;

  /// Text editing controller for [TextFormField].
  TextEditingController get controller;

  /// Button state(Save or Ok).
  ListenableState<String> get buttonState;

  /// Save state.
  ListenableState<EntityState<Profile>> get saveEntityState;

  /// Function to save user info in [Profile].
  void updateAboutMe();
}
