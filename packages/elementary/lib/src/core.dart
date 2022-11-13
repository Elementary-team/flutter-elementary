import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Type for a factory function used to create a [WidgetModel].
///
/// The [WidgetModel] is created once for the [ElementaryWidget] when it
/// is inflating to the tree. If [Elementary] updates its widget [WidgetModel]
/// will not create again. Use the method [WidgetModel.didUpdateWidget] in
/// this case.
typedef WidgetModelFactory<T extends WidgetModel> = T Function(
  BuildContext context,
);

/// A basic interface for every [WidgetModel].
abstract class IWidgetModel {}

/// A widget that uses information and properties of the [WidgetModel] to
/// build a part of the user interface described by this widget.
///
/// This widget is a starting or updating configuration for the [WidgetModel].
///
/// This widget doesn't have its own [RenderObject], and just describes a part
/// of the user interface using other widgets. The same behavior as other
/// widgets which inflate to [ComponentElement]. See also [StatelessWidget],
/// [StatefulWidget], [InheritedWidget].
///
/// An instance of the [WidgetModelFactory] must be provided to the widget
/// constructor into the [wmFactory] property, in order to create
/// the [WidgetModel] instance for this widget.
/// This property can also be used to test this widget by passing a fake factory
/// that returns a mock instead real [WidgetModel].
abstract class ElementaryWidget<I extends IWidgetModel> extends Widget {
  /// The factory function used to create a [WidgetModel].
  final WidgetModelFactory wmFactory;

  /// Creates an instance of ElementaryWidget.
  const ElementaryWidget(
    this.wmFactory, {
    Key? key,
  }) : super(key: key);

  /// Creates a [Elementary] to manage this widget's location in the tree.
  ///
  /// It is uncommon for subclasses to override this method.
  @override
  Element createElement() {
    return Elementary(this);
  }

  /// Describes the part of the user interface represented by this widget,
  /// based on the state of the [WidgetModel] passed by [wm].
  ///
  /// There is no access to the [BuildContext] in this method,
  /// because all needed in this method should be provided by
  /// [WidgetModel] which has direct access to the [BuildContext].
  /// It is uncommon to use [BuildContext] here, possibly in this case you need
  /// to improve implementation of the [WidgetModel] of this widget.
  /// But all widgets that used in this method to describe the user interface
  /// CAN use [BuildContext] as they needed.
  Widget build(I wm);
}

/// The basic implementation of the entity that contains all presentation logic,
/// properties with data for the widget, and relations with the business logic
/// in the form of [ElementaryModel].
///
/// This class contains all internal mechanisms and process that need to
/// guarantee the conceived behavior. In the subclasses you need to expand it
/// only with specific behaviour that needed by the described part
/// of the user interface.
abstract class WidgetModel<W extends ElementaryWidget,
    M extends ElementaryModel> with Diagnosticable implements IWidgetModel {
  final M _model;

  /// Instance of [ElementaryModel] for this [WidgetModel].
  ///
  /// The only business logic dependency that is needed for the [WidgetModel].
  @protected
  @visibleForTesting
  M get model => _model;

  /// Widget that uses [WidgetModel] for the building part of user interface.
  ///
  /// The [WidgetModel] is associated with the [Widget] by [Elementary]. This
  /// association is temporary and can be changed when [Elementary] updates its
  /// link to the widget. Before the first update this field contains
  /// a widget that created this [WidgetModel].
  ///
  /// At the any time this field contains the actual configuration as a widget.
  @protected
  @visibleForTesting
  W get widget => _widget!;

  /// The location in the tree where this widget builds.
  ///
  /// The [WidgetModel] will be associated with the [BuildContext] by
  /// [Elementary] after creating and before calling [initWidgetModel].
  /// The association is permanent: the [WidgetModel] object will never
  /// change its [BuildContext]. However, the [BuildContext] itself can be
  /// moved around the tree.
  ///
  /// After calling [dispose] the association between the [WidgetModel] and
  /// the [BuildContext] will be broken.
  @protected
  @visibleForTesting
  BuildContext get context {
    assert(() {
      if (_element == null) {
        throw FlutterError('This widget has been unmounted');
      }
      return true;
    }());
    return _element!;
  }

  /// Whether [WidgetModel] and [Elementary] are currently mounted in the tree.
  @protected
  @visibleForTesting
  bool get isMounted => _element != null;

  Elementary? _element;
  W? _widget;

  /// Creates an instance of the [WidgetModel].
  WidgetModel(this._model);

  /// Called at first build for initialization of this Widget Model.
  @protected
  @mustCallSuper
  @visibleForTesting
  void initWidgetModel() {
    _model
      ..init()
      .._wmHandler = onErrorHandle;
  }

  /// Called whenever the widget configuration changes.
  @protected
  @visibleForTesting
  void didUpdateWidget(W oldWidget) {}

  /// Called when a dependency of this Widget Model changes.
  ///
  /// For example, if Widget Model has reference an
  /// [InheritedWidget] that later changed, this
  /// method will called to notify about change.
  ///
  /// This method is also called immediately after [initWidgetModel].
  /// It is safe to call [BuildContext.dependOnInheritedWidgetOfExactType]
  /// from this method.
  @protected
  @visibleForTesting
  void didChangeDependencies() {}

  /// Called whenever the Model use method handleError.
  ///
  /// This method is the place for presentation handling error like a
  /// showing snackbar or something else.
  @protected
  @visibleForTesting
  void onErrorHandle(Object error) {}

  /// Called when this WidgetModel and Elementary are removed from the tree.
  ///
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.deactivate()`.
  @protected
  @mustCallSuper
  @visibleForTesting
  void deactivate() {}

  /// Called when this WidgetModel and Elementary are reinserted into the tree
  /// after having been removed via [deactivate].
  ///
  /// In most cases, after a WidgetModel has been deactivated, it is not
  /// reinserted into the tree, and its [dispose] method will be called to
  /// signal that it is ready to be garbage collected.
  ///
  /// In some cases, however, after a WidgetModel has been deactivated, it will
  /// reinserted it into another part of the tree (e.g., if the
  /// subtree containing this Elementary of this WidgetModel is grafted from
  /// one location in the tree to another due to the use of a [GlobalKey]).
  ///
  /// This method does not called the first time a WidgetModel object
  /// is inserted into the tree. Instead, calls [initWidgetModel] in
  /// that situation.
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.activate()`.
  @protected
  @mustCallSuper
  @visibleForTesting
  void activate() {}

  /// Called when element with this Widget Model is removed from the tree
  /// permanently.
  @protected
  @mustCallSuper
  @visibleForTesting
  void dispose() {
    _model.dispose();
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload. Most cases therefore do not need to do
  /// anything in the [reassemble] method.
  ///
  /// See also:
  ///  * [Element.reassemble]
  ///  * [BindingBase.reassembleApplication]
  @protected
  @mustCallSuper
  @visibleForTesting
  void reassemble() {}

  /// Method for setup WidgetModel for testing.
  /// This method can be used to set widget.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupTestWidget(W? testWidget) {
    _widget = testWidget;
  }

  /// Method for setup WidgetModel for testing.
  /// This method can be used to set element (BuildContext).
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupTestElement(Elementary? testElement) {
    _element = testElement;
  }
}

/// An element for managing a widget whose display depends on the Widget Model.
class Elementary extends ComponentElement {
  @override
  ElementaryWidget get widget => super.widget as ElementaryWidget;

  late WidgetModel _wm;

  // private _firstBuild hack
  bool _isInitialized = false;

  /// Create an instance of Elementary.
  Elementary(ElementaryWidget widget) : super(widget);

  @override
  Widget build() {
    return widget.build(_wm);
  }

  @override
  void update(ElementaryWidget newWidget) {
    super.update(newWidget);

    final oldWidget = _wm.widget;
    _wm
      .._widget = newWidget
      ..didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _wm.didChangeDependencies();
  }

  @override
  void activate() {
    super.activate();
    _wm.activate();

    markNeedsBuild();
  }

  @override
  void deactivate() {
    _wm.deactivate();
    super.deactivate();
  }

  @override
  void unmount() {
    super.unmount();

    _wm
      ..dispose()
      .._element = null
      .._widget = null;
  }

  @override
  void performRebuild() {
    // private _firstBuild hack
    if (!_isInitialized) {
      _wm = widget.wmFactory(this);
      _wm
        .._element = this
        .._widget = widget
        ..initWidgetModel()
        ..didChangeDependencies();

      _isInitialized = true;
    }

    super.performRebuild();
  }

  @override
  void reassemble() {
    super.reassemble();

    _wm.reassemble();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties
      ..add(
        DiagnosticsProperty<WidgetModel>(
          'widget model',
          _wm,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<ElementaryModel>(
          'model',
          _wm.model,
          defaultValue: null,
        ),
      );
  }
}

/// Class that contains a business logic for Widget.
///
/// You can write this freestyle. It may be collection of methods,
/// streams or something else.
///
/// This class can take [ErrorHandler] for handling caught error
/// like a logging or something else. This realize by using
/// [handleError] method. This method also notifies the Widget Model about the
/// error that has occurred. You can use onErrorHandle method of Widget Model
/// to handle on UI like show snackbar or something else.
abstract class ElementaryModel {
  final ErrorHandler? _errorHandler;
  void Function(Object)? _wmHandler;

  /// Create an instance of ElementaryModel.
  ElementaryModel({ErrorHandler? errorHandler}) : _errorHandler = errorHandler;

  /// Should be used for report error Error Handler if it was set and notify
  /// Widget Model about error.
  @protected
  @mustCallSuper
  @visibleForTesting
  void handleError(Object error, {StackTrace? stackTrace}) {
    _errorHandler?.handleError(error, stackTrace: stackTrace);
    _wmHandler?.call(error);
  }

  /// Method for initialize this Model.
  ///
  /// Will be call at first build when Widget Model created.
  void init() {}

  /// Called when Widget Model disposing.
  void dispose() {}

  /// Method for setup ElementaryModel for testing.
  /// This method can be used to WidgetModels error handler.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupWmHandler(Function(Object)? function) {
    _wmHandler = function;
  }
}
