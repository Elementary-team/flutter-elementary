import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/domain/entity/app_coordinate.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen_model.dart';
import 'package:provider/provider.dart';

/// Factory for [InterestsScreenWidgetModel].
InterestsScreenWidgetModel interestsScreenWidgetModelFactory(
    BuildContext context,
    ) {
  final appDependencies = context.read<IAppScope>();
  final model = InterestsScreenModel(
    appDependencies.profileBloc,
    appDependencies.errorHandler,
  );
  return InterestsScreenWidgetModel(model);
}

/// Widget Model for [InterestsScreen].
class InterestsScreenWidgetModel
    extends WidgetModel<InterestsScreen, InterestsScreenModel>
    implements IInterestsScreenWidgetModel {
  late final Coordinator _coordinator;

  /// Create an instance [InterestsScreenWidgetModel].
  InterestsScreenWidgetModel(
      InterestsScreenModel model,
      ) : super(model);

  @override
  void initWidgetModel() {
    _coordinator = context.read<IAppScope>().coordinator;
    super.initWidgetModel();
  }

  @override
  void saveInterestsInProfile() {
    _coordinator.navigate(context, AppCoordinate.aboutMeScreen);
  }

}

/// Interface of [IInterestsScreenWidgetModel].
abstract class IInterestsScreenWidgetModel extends IWidgetModel {
  /// Function to save list interests in [Profile].
  void saveInterestsInProfile() {}
}
