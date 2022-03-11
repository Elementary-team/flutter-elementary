import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/strings/interests_screen_strings.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/domain/entity/app_coordinate.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen_model.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_state.dart';
import 'package:profile/util/dialog_controller.dart';
import 'package:provider/provider.dart';

/// Factory for [InterestsScreenWidgetModel].
InterestsScreenWidgetModel interestsScreenWidgetModelFactory(
  BuildContext context,
) {
  final appDependencies = context.read<IAppScope>();
  final model = InterestsScreenModel(
    appDependencies.profileBloc,
    appDependencies.mockInterestsRepository,
    appDependencies.errorHandler,
  );
  final coordinator = appDependencies.coordinator;
  final dialogController = appDependencies.dialogController;
  return InterestsScreenWidgetModel(
    model: model,
    coordinator: coordinator,
    dialogController: dialogController,
  );
}

/// Widget Model for [InterestsScreen].
class InterestsScreenWidgetModel
    extends WidgetModel<InterestsScreen, InterestsScreenModel>
    implements IInterestsScreenWidgetModel {
  /// Coordinator for navigation.
  final Coordinator coordinator;

  /// Controller for show [SnackBar].
  final DialogController dialogController;

  final _listUserInterestsState = StateNotifier<List<String>>();
  final _listAllInterestsEntityState = EntityStateNotifier<List<String>>();

  @override
  ListenableState<List<String>> get listUserInterestsState =>
      _listUserInterestsState;

  @override
  ListenableState<EntityState<List<String>>> get listAllInterestsEntityState =>
      _listAllInterestsEntityState;

  /// Create an instance [InterestsScreenWidgetModel].
  InterestsScreenWidgetModel({
    required InterestsScreenModel model,
    required this.coordinator,
    required this.dialogController,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _initInterests();
    _initListAllInterests();
  }

  @override
  void dispose() {
    _listAllInterestsEntityState.dispose();
    _listUserInterestsState.dispose();
    super.dispose();
  }

  @override
  void updateInterests() {
    if (_listUserInterestsState.value!.isNotEmpty) {
      model.updateInterests(_listUserInterestsState.value);
      coordinator.navigate(context, AppCoordinates.aboutMeScreen);
    } else {
      dialogController.showSnackBar(
        context,
        InterestsScreenStrings.warningValidation,
      );
    }
  }

  @override
  void onChanged({
    required String interest,
  }) {
    final currentListUserInterest = _listUserInterestsState.value!.toList();
    if (!currentListUserInterest.contains(interest)) {
      currentListUserInterest.add(interest);
    } else {
      currentListUserInterest.remove(interest);
    }
    _listUserInterestsState.accept(currentListUserInterest);
  }

  Future<void> _initListAllInterests() async {
    _listAllInterestsEntityState.loading();
    try {
      final listAllInterests = await model.getInterestsList();
      _listAllInterestsEntityState.content(listAllInterests);
    } on Exception catch (_) {
      _listAllInterestsEntityState.error();
    }
  }

  void _initInterests() {
    final state = model.currentState;
    if (state is ProfileContentState) {
      final currentState = state as IEditingAvailable;
      final profile = currentState.profile;
      final initListInterests = profile.interests;
      if (initListInterests != null && initListInterests.isNotEmpty) {
        _listUserInterestsState.accept(initListInterests);
      } else {
        _listUserInterestsState.accept([]);
      }
    }
  }
}

/// Interface of [IInterestsScreenWidgetModel].
abstract class IInterestsScreenWidgetModel extends IWidgetModel {
  /// All interest list state.
  ListenableState<EntityState<List<String>>> get listAllInterestsEntityState;

  /// Status of selected checkboxes.
  ListenableState<List<String>> get listUserInterestsState;

  /// Function to save list interests in [Profile].
  void updateInterests();

  /// Callback on click on [Checkbox].
  void onChanged({
    required String interest,
  });
}
