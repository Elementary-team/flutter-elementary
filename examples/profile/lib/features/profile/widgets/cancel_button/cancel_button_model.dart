import 'package:elementary/elementary.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_bloc.dart';
import 'package:profile/features/profile/service/profile_bloc/profile_event.dart';
import 'package:profile/features/profile/widgets/cancel_button/cancel_button.dart';

/// Model for [CancelButton].
class CancelButtonModel extends ElementaryModel {
  /// Bloc for working with profile states.
  final ProfileBloc _profileBloc;

  /// Create an instance [CancelButtonModel].
  CancelButtonModel(
    this._profileBloc,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  /// Cancel editing.
  void cancel() {
    _profileBloc.add(CancelEditingEvent());
  }
}
