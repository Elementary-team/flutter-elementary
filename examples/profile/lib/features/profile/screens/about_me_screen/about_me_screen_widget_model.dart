import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/domain/entity/app_coordinate.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen_model.dart';
import 'package:profile/features/profile/screens/place_residence/place_residence_screen.dart';
import 'package:provider/provider.dart';

/// Factory for [AboutMeScreenWidgetModel].
AboutMeScreenWidgetModel aboutMeScreenWidgetModelFactory(
    BuildContext context,) {
  final appDependencies = context.read<IAppScope>();
  final model = AboutMeScreenModel(
    appDependencies.profileBloc,
    appDependencies.errorHandler,
  );
  return AboutMeScreenWidgetModel(model);
}

/// Widget Model for [PlaceResidenceScreen].
class AboutMeScreenWidgetModel
    extends WidgetModel<AboutMeScreen, AboutMeScreenModel>
    implements IAboutMeScreenWidgetModel {
  final _controller = TextEditingController();
  late final Coordinator _coordinator;

  @override
  TextEditingController get controller => _controller;

  String? _currentInfo;

  /// Create an instance [AboutMeScreenWidgetModel].
  AboutMeScreenWidgetModel(AboutMeScreenModel model,) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _coordinator =  context.read<IAppScope>().coordinator;
  }

  @override
  void saveAboutMe() {
    model.saveAboutMeInfo(_currentInfo);
    _coordinator.popUntilRoot();
  }

  @override
  void onFieldSubmitted() {
    if (_controller.text.isNotEmpty) {
      _currentInfo = _controller.text;
    }
  }
}

/// Interface of [AboutMeScreenWidgetModel].
abstract class IAboutMeScreenWidgetModel extends IWidgetModel {
  /// Text editing controller for [TextFormField].
  TextEditingController get controller;

  /// Callback on field submitted.
  void onFieldSubmitted() {}

  /// Function to save user info in [Profile].
  void saveAboutMe() {}
}
