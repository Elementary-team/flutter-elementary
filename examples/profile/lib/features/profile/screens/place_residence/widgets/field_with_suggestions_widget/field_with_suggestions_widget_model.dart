import 'dart:async';

import 'package:async/async.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/profile/screens/place_residence/utils/overlay_entry_controller.dart';
import 'package:profile/features/profile/screens/place_residence/widgets/field_with_suggestions_widget/field_with_suggestions_model.dart';
import 'package:profile/features/profile/screens/place_residence/widgets/field_with_suggestions_widget/field_with_suggestions_widget.dart';
import 'package:provider/provider.dart';

/// Factory for [FieldWithSuggestionsWidgetModel].
FieldWithSuggestionsWidgetModel fieldWithSuggestionsWidgetModelFactory(
  BuildContext context,
) {
  final appDependencies = context.read<IAppScope>();
  final model = FieldWithSuggestionsModel(appDependencies.mockCitiesRepository);
  return FieldWithSuggestionsWidgetModel(
    model: model,
  );
}

/// Widget Model for [FieldWithSuggestionsWidget].
class FieldWithSuggestionsWidgetModel
    extends WidgetModel<FieldWithSuggestionsWidget, FieldWithSuggestionsModel>
    implements IFieldWithSuggestionsWidgetModel {
  /// Text editing controller.
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final _listSuggestionsState = EntityStateNotifier<List<String>>();
  final _overlayEntryController = const OverlayEntryController();
  final _optionsLayerLink = LayerLink();

  @override
  TextEditingController get controller => _controller;

  @override
  FocusNode get focusNode => _focusNode;

  @override
  ListenableState<EntityState<List<String>>> get listSuggestionsState =>
      _listSuggestionsState;

  @override
  LayerLink get optionsLayerLink => _optionsLayerLink;

  Timer? _debounceTimer;
  CancelableOperation<List<String>>? _cancelableCitiesLoader;
  OverlayEntry? _floatingOptions;
  String? _selection;

  /// Create an instance [FieldWithSuggestionsWidgetModel].
  FieldWithSuggestionsWidgetModel({
    required FieldWithSuggestionsModel model,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _controller = widget.controller;
    _controller.addListener(_controllerListener);
    _focusNode = widget.focusNode;
  }

  @override
  void didUpdateWidget(FieldWithSuggestionsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller = widget.controller;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _cancelableCitiesLoader?.cancel();
    _controller.removeListener(_controllerListener);
    _listSuggestionsState.dispose();
    super.dispose();
  }

  void _controllerListener() {
    if (_controller.text == _selection) {
      return;
    }

    _selection = null;
    _listSuggestionsState.loading();

    _updateOverlay();

    _cancelableCitiesLoader?.cancel();
    _cancelableCitiesLoader = null;

    _debounceTimer?.cancel();
    _debounceTimer = _getDebounceCitiesLoader(controller.text);
  }

  Timer _getDebounceCitiesLoader(String pattern) {
    return Timer(
      const Duration(seconds: 1),
      () {
        final cancelableCitiesLoader = _getCancelableCitiesLoader(pattern)
          ..then((cities) {
            _cancelableCitiesLoader = null;
            _listSuggestionsState.content(cities);
            _updateOverlay();
          });
        _cancelableCitiesLoader = cancelableCitiesLoader;
      },
    );
  }

  CancelableOperation<List<String>> _getCancelableCitiesLoader(String pattern) {
    return CancelableOperation<List<String>>.fromFuture(
      model.getListCities(pattern),
    );
  }

  void _updateOverlay() {
    if (_shouldShowOptions()) {
      _floatingOptions?.remove();
      _floatingOptions = _overlayEntryController.createOverlayEntry(
        _listSuggestionsState,
        _onSelected,
        _optionsLayerLink,
      );
      Overlay.of(context, rootOverlay: true)!.insert(_floatingOptions!);
    } else if (_floatingOptions != null) {
      _floatingOptions!.remove();
      _floatingOptions = null;
    }
  }

  bool _shouldShowOptions() {
    return _focusNode.hasFocus &&
        _selection == null &&
        _controller.text.isNotEmpty &&
        _listSuggestionsState.value != null;
  }

  void _onSelected(String value) {
    _focusNode.unfocus();
    _selection = value;
    _controller.text = value;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    _updateOverlay();
  }
}

/// Interface of [FieldWithSuggestionsWidgetModel].
abstract class IFieldWithSuggestionsWidgetModel extends IWidgetModel {
  /// Text editing controller.
  TextEditingController get controller;

  /// Focus node.
  FocusNode get focusNode;

  /// Suggestions state.
  ListenableState<EntityState<List<String>>> get listSuggestionsState;

  /// Layer link for list suggestion.
  LayerLink get optionsLayerLink;
}
