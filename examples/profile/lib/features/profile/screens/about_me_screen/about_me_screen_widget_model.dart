import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/strings/about_me_screen_strings.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen_model.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';
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

/// Widget Model for [PlaceResidenceScreen].
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
  final FocusNode _focusNode = FocusNode();
  late final StreamSubscription<BaseProfileState> _stateStatusStream;

  @override
  FocusNode get focusNode => _focusNode;

  @override
  TextEditingController get controller => _controller;

  @override
  ListenableState<String> get buttonState => _buttonState;

  @override
  ListenableState<EntityState<Profile>> get saveEntityState => _saveEntityState;

  String? _currentInfo;

  /// Create an instance [AboutMeScreenWidgetModel].
  AboutMeScreenWidgetModel({
    required AboutMeScreenModel model,
    required this.coordinator,
    required this.dialogController,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _stateStatusStream = model.profileStateStream.listen(_updateState);
    _initProfile();
    _initButtonState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _stateStatusStream.cancel();
    super.dispose();
  }

  @override
  void updateAboutMe() {
    focusNode.unfocus();
    model.updateAboutMe(_currentInfo);
    final currentState = model.currentState;
    if (currentState is! PendingProfileState) {
      coordinator.popUntilRoot();
    }
  }

  @override
  void onChanged(String newText) {
    if (_currentInfo != newText) {
      _currentInfo = newText;
      _buttonState.accept(AboutMeScreenStrings.saveButtonTitle);
    }
  }

  void _initProfile() {
    final state = model.currentState;
    if (state is ProfileState) {
      final profile = state.profile;
      if (profile.aboutMe != null) {
        _controller.text = profile.aboutMe!;
        _currentInfo = profile.aboutMe;
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
      dialogController.showSnackBar(context, AboutMeScreenStrings.errorSnackBar);
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

  /// Callback on field submitted.
  void onChanged(String newValue) {}

  /// Function to save user info in [Profile].
  void updateAboutMe() {}
}
