import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Type for a factory function that is used to create
/// an instance of [WidgetModel].
///
/// ## The part of Elementary Lifecycle
/// The [WidgetModel] instance is created for the [ElementaryWidget] when it
/// instantiate into the tree. Only in this moment the factory is called once(*)
/// to get the instance of the [WidgetModel] and associate it with
/// the [Elementary]. After this the [WidgetModel] will alive while
/// the [Elementary] is alive. If [Elementary] updates the widget associated
/// with it, the [WidgetModel] will not be recreated and continue work with
/// the same state that has before the update. But the [WidgetModel] will be
/// notified about the update by calling the method
/// [WidgetModel.didUpdateWidget]. All needed state adjustments can be
/// handle inside this method.
///
/// (*) Once per insert into the tree. As all other widgets, an instance of
/// [ElementaryWidget] can be inserted many times. Every time the element and
/// separate [WidgetModel] will be created for manage different state for every
/// concrete inserts.
///
/// ## Examples
/// {@tool snippet}
///
/// The following is a an example for the top-level factory function
/// that creates dependencies right on the spot.
///
/// ```dart
/// ExampleWidgetModel exampleWidgetModelFactory(BuildContext context) {
///   final modelDependency = ModelDependency();
///   final exampleModel = ExampleModel(modelDependency);
///   return ExampleWidgetModel(exampleModel);
/// }
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// The following is a an example for the top-level factory function
/// that creates dependencies using one of the DI containers.
///
/// ```dart
/// ExampleWidgetModel exampleWidgetModelFactory(BuildContext context) {
///   final exampleModel = ContainerInstance.createExampleModel();
///   return ExampleWidgetModel(exampleModel);
/// }
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// The following is a an example for the top-level factory function
/// that get dependencies using passed BuildContext.
///
/// ```dart
/// ExampleWidgetModel exampleWidgetModelFactory(BuildContext context) {
///   final modelDependency = ModelDependency();
///   final exampleModel = ExampleModel(modelDependency);
///   final widgetModelAnotherDependency = SomeWidget.of(context).getSomething;
///   return ExampleWidgetModel(exampleModel, widgetModelAnotherDependency);
/// }
/// ```
/// {@end-tool}
typedef WidgetModelFactory<T extends WidgetModel> = T Function(
  BuildContext context,
);

/// A basic interface for every [WidgetModel].
///
/// The general approach for the [WidgetModel] is implement interface that
/// expanded from [IWidgetModel]. This expanded interface describes the contract
/// which the inheritor of the [WidgetModel] implemented this interface
/// is providing for the [ElementaryWidget]. The contract includes all
/// properties and methods which the [ElementaryWidget] can use for build a
/// part of the tree it describes.
///
/// {@tool snippet}
///
/// The following is a an example for the top-level factory function
/// that get dependencies using passed BuildContext.
///
/// ```dart
/// abstract interface class IExampleWidgetModel implements IWidgetModel {
///   ListenableState<int> get somePublisher;
///   Stream<String> get anotherPublisher;
///   Color get justProperty;
///
///   Future<void> doSomething();
///   Future<void> anotherOptionOfInteract();
/// }
/// ```
/// {@end-tool}
abstract interface class IWidgetModel {}

/// A widget that uses state of [WidgetModel] properties to
/// build a part of the user interface described by this widget.
///
/// For inheritors of this widget is common to be parameterized by
/// the interface expanded from [IWidgetModel] that provides all special
/// information which needed for this widget for correctly describe the subtree.
///
/// Only one thing should be implemented in inheritors of this widget is a
/// build method. Build method in this case is pure function which gets the
/// [WidgetModel] as argument and based on this [WidgetModel] returns
/// the [Widget]. There isn't additional interactions with anything external,
/// everything needed for describe should be provided by [WidgetModel].
///
/// {@tool snippet}
///
/// The following widget shows a default example of Flutter app, which created
/// with a new Flutter project.
///
/// ```dart
/// class ExampleWidget extends ElementaryWidget<IExampleWidgetModel> {
///   const ExampleWidget({
///     Key? key,
///     WidgetModelFactory wmFactory = exampleWidgetModelFactory,
///   }) : super(wmFactory, key: key);
///
///   @override
///   Widget build(IExampleWidgetModel wm) {
///     return Scaffold(
///       appBar: AppBar(
///         title: const Text('Test'),
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: <Widget>[
///             const Text('You have pushed the button this many times:'),
///             ValueListenableBuilder<int>(
///               valueListenable: wm.pressCountPublisher,
///               builder: (_, value, __) {
///                 return Text(value.toString());
///               },
///             ),
///           ],
///         ),
///       ),
///       floatingActionButton: FloatingActionButton(
///         onPressed: wm.increment,
///         tooltip: 'Increment',
///         child: const Icon(Icons.add),
///       ),
///     );
///   }
/// }
/// ```
/// {@end-tool}
///
/// ## wmFactory
/// An instance of the [WidgetModelFactory] must be provided to the widget
/// constructor as [wmFactory] property. This is required to create
/// the [WidgetModel] instance for this widget.
/// You can use additional factories for different purpose. For example create
/// a special one that returns a mock [WidgetModel] for the tests.
///
/// ## The part of Elementary Lifecycle
/// This widget is a starting and updating configuration for the [WidgetModel].
/// More details about using it while life cycle see in the methods docs of the
/// [WidgetModel].
///
/// ## Internal details
/// This widget doesn't have its own [RenderObject], and just describes a part
/// of the user interface using other widgets. It is a common approach for the
/// widgets those inflate to [ComponentElement].
///
/// See also: [StatelessWidget], [StatefulWidget], [InheritedWidget].
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
  Elementary createElement() {
    return Elementary(this);
  }

  /// Describes the part of the user interface represented by this widget,
  /// based on the state of the [WidgetModel] passed to the [wm] argument.
  ///
  /// There is no access to the [BuildContext] in this method,
  /// because all needed in this method should be provided by
  /// [WidgetModel] which has direct access to the [BuildContext].
  /// It is uncommon to use [BuildContext] here, possibly in this case you need
  /// to improve implementation of the [WidgetModel].
  /// But [BuildContext] CAN be used in all builder functions and all widgets
  /// used here.
  Widget build(I wm);
}

/// The basic implementation of the entity responsible for all
/// presentation logic, providing properties and data for the widget,
/// and keep relations with the business logic. Business logic represented in
/// the form of [ElementaryModel].
///
/// [WidgetModel] is a working horse of the Elementary library. It unites the
/// trio of 'widget - widget model - model'. So the inheritors of [WidgetModel]
/// parameterized by an inheritor of the ElementaryWidget and an inheritor
/// of the ElementaryModel. This mean that this WidgetModel subclass encapsulate
/// all required logic for the concrete ElementaryWidget subclass that
/// mentioned as parameter and only for it. Also this WidgetModel subclass uses
/// exactly the mentioned ElementaryModel subclass as an available contract of
/// business logic.
///
/// It is common for inheritors to implement the expanded from [IWidgetModel]
/// interface that describes special contract for the relevant
/// [ElementaryWidget] subclass. Moreover using the contract is preferable way
/// because this interface explicitly shows available properties and methods
/// for declarative part (for ElementaryWidget).
///
/// ## Approach to update
/// It is a rare case when [ElementaryWidget] completely rebuild. The most
/// common case is a partial rebuild of UI parts. In order to get this, using
/// publishers can be helpful. Declare any publishers which you prefer and
/// update their values in suitable conditions. In the declarative part just
/// use these publishers for describe parts of the UI, which depends on them.
/// Here is a far from complete list of options for use as publishers:
/// [Stream], [ChangeNotifier], [StateNotifier], [EntityStateNotifier].
///
/// ## The part of Elementary Lifecycle
/// Base class contains all internal mechanisms and process that need to
/// guarantee the conceived behavior for the Elementary library.
///
/// [initWidgetModel] is called only once for lifecycle
/// of the [WidgetModel] in the really beginning before the first build.
/// It can be used for initiate a starting state of the [WidgetModel].
///
/// [didUpdateWidget] called whenever widget instance in the tree has been
/// updated. Common case where rebuild comes from the top. This method is a good
/// place for update state of the [WidgetModel] based on the new configuration
/// of widget. When this method is called is just a signal for decide what
/// exactly should be updated or rebuilt. The fact of update doesn't mean that
/// build method of the widget will be called. Set new values to publishers
/// for rebuild concrete parts of the UI.
///
/// [didChangeDependencies] called whenever dependencies which [WidgetModel]
/// subscribed with [BuildContext] change.
/// When this method is called is just a signal for decide what
/// exactly should be updated or rebuilt. The fact of update doesn't mean that
/// build method of the widget will be called. Set new values to publishers
/// for rebuild concrete parts of the UI.
///
/// [deactivate] called when the [WidgetModel] with [Elementary] removed from
/// the tree.
///
/// [activate] called when [WidgetModel] with [Elementary] are reinserted into
/// the tree after having been removed via [deactivate].
///
/// [dispose] called when [WidgetModel] is going to be permanently destroyed.
///
/// [reassemble] called whenever the application is reassembled during
/// debugging, for example during the hot reload.
///
/// [onErrorHandle] called when the [ElementaryModel] handle error with the
/// [ElementaryModel.handleError] method. Can be useful for general handling
/// errors such as showing snack-bars.
abstract class WidgetModel<W extends ElementaryWidget,
    M extends ElementaryModel> with Diagnosticable implements IWidgetModel {
  final M _model;

  /// Instance of [ElementaryModel] for this [WidgetModel].
  ///
  /// The only business logic dependency that is needed for the [WidgetModel].
  @protected
  @visibleForTesting
  M get model => _model;

  /// Widget that uses this [WidgetModel] for building part of the user interface.
  ///
  /// The [WidgetModel] has an associated [ElementaryWidget].
  /// This relation is managed by [Elementary], and in every time of lifecycle
  /// in this property is an actual widget. Before the first update this field
  /// contains a widget that created this [WidgetModel]. This instance can be
  /// changed during the lifecycle, and [didUpdateWidget] will be called each
  /// time it is changed.
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

  BuildContext? _element;
  W? _widget;

  /// Creates an instance of the [WidgetModel].
  WidgetModel(this._model);

  /// Called while the first build for initialization of this [WidgetModel].
  ///
  /// This method is called only ones for the instance of [WidgetModel]
  /// during its lifecycle.
  @protected
  @mustCallSuper
  @visibleForTesting
  void initWidgetModel() {
    _model
      ..init()
      .._wmHandler = onErrorHandle;
  }

  /// Called whenever the widget configuration is changed.
  @protected
  @visibleForTesting
  void didUpdateWidget(W oldWidget) {}

  /// Called when a dependency (by Build Context) of this Widget Model changes.
  ///
  /// For example, if Widget Model has reference on [InheritedWidget].
  /// This widget can change and method will called to notify about change.
  ///
  /// This method is also called immediately after [initWidgetModel].
  @protected
  @visibleForTesting
  void didChangeDependencies() {}

  /// Called whenever [ElementaryModel.handleError] is called.
  ///
  /// This method is a common place for presentation handling error like a
  /// showing a snack-bar, etc.
  @protected
  @visibleForTesting
  void onErrorHandle(Object error) {}

  /// Called when this [WidgetModel] and [Elementary] are removed from the tree.
  ///
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.deactivate()`.
  @protected
  @mustCallSuper
  @visibleForTesting
  void deactivate() {}

  /// Called when this [WidgetModel] and [Elementary] are reinserted into
  /// the tree after having been removed via [deactivate].
  ///
  /// In most cases, after a [WidgetModel] has been deactivated, it is not
  /// reinserted into the tree, and its [dispose] method will be called to
  /// signal that it is ready to be garbage collected.
  ///
  /// In some cases, however, after a [WidgetModel] has been deactivated,
  /// it will reinserted it into another part of the tree (e.g., if there is a
  /// subtree uses a [GlobalKey] that match with key of the [Elementary]
  /// linked with this [WidgetModel]).
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

  /// Called when [Elementary] with this [WidgetModel] is removed from the tree
  /// permanently.
  /// Should be used for preparation to be garbage collected.
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

  /// Method for associate another instance of the widget to this [WidgetModel].
  /// MUST be used only for testing purposes.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupTestWidget(W? testWidget) {
    _widget = testWidget;
  }

  /// Method for associate another element to this [WidgetModel].
  /// MUST be used only for testing purposes.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupTestElement(BuildContext? testElement) {
    _element = testElement;
  }
}

/// An element for managing a widget whose display depends on the Widget Model.
final class Elementary extends ComponentElement {
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

/// The base class for an entity that contains a business logic required for
/// a specific inheritor of [ElementaryWidget].
///
/// You can implement this class freestyle. It may be a bunch of methods,
/// streams or something else. Also it is not a mandatory for business logic
/// to be implemented right inside the class, this model can be proxy for other
/// responsible entities with business logic.
///
/// This class can take [ErrorHandler] as dependency for centralize handling
/// error (for example logging). The [handleError] method can be used for it.
/// When the [handleError] is called passed [ErrorHandler] handles exception.
/// Also the [WidgetModel] is notified about this exception with
/// [WidgetModel.onErrorHandle] method.
///
/// ## The part of Elementary Lifecycle
///
abstract class ElementaryModel {
  final ErrorHandler? _errorHandler;
  void Function(Object)? _wmHandler;

  /// Create an instance of ElementaryModel.
  ElementaryModel({ErrorHandler? errorHandler}) : _errorHandler = errorHandler;

  /// Can be used for send [error] to [ErrorHandler] if it defined and notify
  /// [WidgetModel].
  @protected
  @mustCallSuper
  @visibleForTesting
  void handleError(Object error, {StackTrace? stackTrace}) {
    _errorHandler?.handleError(error, stackTrace: stackTrace);
    _wmHandler?.call(error);
  }

  /// Initializes [ElementaryModel].
  ///
  /// Called once before the first build of the [ElementaryWidget].
  void init() {}

  /// Prepares the [ElementaryModel] to be completely destroyed.
  ///
  /// Called once when [Elementary] going to be destroyed. Should be used for
  /// clearing links, subscriptions, and preparation to be garbage collected.
  void dispose() {}

  /// Method for setup ElementaryModel for testing.
  /// This method can be used to WidgetModels error handler.
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void setupWmHandler(void Function(Object)? function) {
    _wmHandler = function;
  }
}

/// Mock that helps to prevent [NoSuchMethodError] exception when the
/// ElementaryModel is mocked.
@visibleForTesting
mixin MockElementaryModelMixin implements ElementaryModel {
  @override
  set _wmHandler(void Function(Object)? _) {}
}

/// Mock that helps to prevent [NoSuchMethodError] exception when the
/// WidgetModel is mocked.
@visibleForTesting
mixin MockWidgetModelMixin<W extends ElementaryWidget,
    M extends ElementaryModel> implements WidgetModel<W, M> {
  @override
  set _element(BuildContext? _) {}

  @override
  set _widget(W? _) {}
}
