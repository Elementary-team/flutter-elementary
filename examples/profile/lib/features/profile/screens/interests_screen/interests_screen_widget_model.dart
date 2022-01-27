import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/strings/interests_screen_strings.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/common/dialog_controller.dart';
import 'package:profile/features/navigation/domain/entity/app_coordinate.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen_model.dart';
import 'package:profile/features/profile/service/bloc/profile_state.dart';
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
  final coordinator = context.read<IAppScope>().coordinator;
  final dialogController = context.read<IAppScope>().dialogController;
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

  late final List<String> _listAllInterests;
  final _listUserInterestsState = StateNotifier<List<String>>();

  @override
  List<String> get listAllInterests => _listAllInterests;

  @override
  ListenableState<List<String>> get listUserInterestsState =>
      _listUserInterestsState;

  /// Create an instance [InterestsScreenWidgetModel].
  InterestsScreenWidgetModel({
    required InterestsScreenModel model,
    required this.coordinator,
    required this.dialogController,
  }) : super(model);

  @override
  void initWidgetModel() {
    _initInterests();
    _listAllInterests = model.getMockInterestsList();
    super.initWidgetModel();
  }

  @override
  void saveInterestsInProfile() {
    if (_listUserInterestsState.value!.isNotEmpty) {
      model.saveListInterests(_listUserInterestsState.value);
      coordinator.navigate(context, AppCoordinate.aboutMeScreen);
    } else {
      dialogController.showSnackBar(
        context,
        InterestsScreenStrings.warning,
      );
    }
  }

  @override
  bool isChecked(String interest) {
    if (_listUserInterestsState.value!.isEmpty ||
        !_listUserInterestsState.value!.contains(interest)) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void onChanged({
    required String interest,
    bool? isChecked,
  }) {
    final currentListUserInterest = _listUserInterestsState.value!.toList();
    if (isChecked != null && isChecked) {
      currentListUserInterest.add(interest);
    } else if (currentListUserInterest.contains(interest) &&
        isChecked != null &&
        !isChecked) {
      currentListUserInterest.remove(interest);
    }
    _listUserInterestsState.accept(currentListUserInterest);
  }

  void _initInterests() {
    final state = model.currentState;
    if (state is ProfileState) {
      final profile = state.profile;
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
  /// List interests.
  List<String> get listAllInterests;

  /// Status of selected checkboxes.
  ListenableState<List<String>> get listUserInterestsState;

  /// Function to save list interests in [Profile].
  void saveInterestsInProfile() {}

  /// Function that determines if a checkbox is checked.
  bool isChecked(String interest) {
    return false;
  }

  /// Callback on click on [Checkbox].
  void onChanged({
    required String interest,
    bool? isChecked,
  }) {}
}
