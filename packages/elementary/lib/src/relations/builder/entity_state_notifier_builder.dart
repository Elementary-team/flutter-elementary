import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Builder that uses [ValueListenable] parametrized by [EntityState] as
/// a source of data.
/// Usually can be helpful with the [EntityStateNotifier].
///
/// This builder uses 3 possible builders function:
/// [errorBuilder] - for the case when [listenableEntityState] value is error
/// state of [EntityState].
/// [loadingBuilder] - for the case when [listenableEntityState] value is
/// loading state of [EntityState].
/// [builder] - the default one includes all previous when [errorBuilder] and
/// [loadingBuilder] are not set, and for the content state of [EntityState].
class EntityStateNotifierBuilder<T> extends StatelessWidget {
  /// Source that used to detect change and rebuild.
  final ValueListenable<EntityState<T>> listenableEntityState;

  /// Default builder that is used for the content state and all other states if
  /// special builders are not specified.
  final DataWidgetBuilder<T> builder;

  /// Builder that used for the loading state.
  /// See also:
  /// [EntityState], [LoadingEntityState]
  final LoadingWidgetBuilder<T>? loadingBuilder;

  /// Builder that used for the error state.
  /// See also:
  /// [EntityState], [LoadingEntityState]
  final ErrorWidgetBuilder<T>? errorBuilder;

  /// Create an instance of EntityStateNotifierBuilder.
  const EntityStateNotifierBuilder({
    Key? key,
    required this.listenableEntityState,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EntityState<T>>(
      valueListenable: listenableEntityState,
      builder: (ctx, entity, _) {
        final eBuilder = errorBuilder;
        if (entity.isErrorState && eBuilder != null) {
          return eBuilder(ctx, entity.errorOrNull, entity.data);
        }

        final lBuilder = loadingBuilder;
        if (entity.isLoadingState && lBuilder != null) {
          return lBuilder(ctx, entity.data);
        }

        return builder(ctx, entity.data);
      },
    );
  }
}

/// Builder function for loading state.
/// See also:
///   [EntityState] - State of some logical entity.
typedef LoadingWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T? data,
);

/// Builder function for content state.
/// See also:
///   [EntityState] - State of some logical entity.
typedef DataWidgetBuilder<T> = Widget Function(BuildContext context, T? data);

/// Builder function for error state.
/// See also:
///   [EntityState] - State of some logical entity.
typedef ErrorWidgetBuilder<T> = Widget Function(
  BuildContext context,
  Exception? e,
  T? data,
);
