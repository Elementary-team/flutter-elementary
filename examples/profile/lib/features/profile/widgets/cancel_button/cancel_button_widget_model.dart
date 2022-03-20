import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:profile/features/profile/widgets/cancel_button/cancel_button.dart';
import 'package:profile/features/profile/widgets/cancel_button/cancel_button_model.dart';
import 'package:provider/provider.dart';

/// Factory for [CancelButtonWidgetModel].
CancelButtonWidgetModel cancelButtonWidgetModelFactory(
  BuildContext context,
) {
  final appDependencies = context.read<IAppScope>();
  final model = CancelButtonModel(
    appDependencies.profileBloc,
    appDependencies.errorHandler,
  );
  final coordinator = appDependencies.coordinator;
  return CancelButtonWidgetModel(
    coordinator,
    model,
  );
}

/// Widget Model for [CancelButton].
class CancelButtonWidgetModel
    extends WidgetModel<CancelButton, CancelButtonModel>
    implements ICancelButtonWidgetModel {
  final Coordinator _coordinator;

  /// Create an instance [CancelButtonWidgetModel].
  CancelButtonWidgetModel(
    this._coordinator,
    CancelButtonModel model,
  ) : super(model);

  @override
  void cancel() {
    model.cancel();
    _coordinator.popUntilRoot();
  }
}

/// Interface of [CancelButtonWidgetModel].
abstract class ICancelButtonWidgetModel extends IWidgetModel {
  /// Cancel editing.
  void cancel();
}
