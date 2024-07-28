## Define the part

Deside what part of the user interface you are going to work on. Choose a name that accurately describes it, you will use it when creating files.

!!! tip
    You can choose any part of the UI that makes semantic sense and has its own presentation and business logic: the whole screen, a tab, even a small button. But in most common cases, it is a screen.

## Create classes:

Using a chosen tool create classes for ElementaryModel, WidgetModel, ElementaryWidget.

=== "Plugin for IntelliJ"
 
    **1.** Choose the location where the ElementaryModel, ElementaryWidgetModel, and ElementaryWidget will be located.

    **2.** Open the Context Menu on that dirrectory.

    **3.** Choose 'New' -> 'Elementary Module'.

    **4.** Enter the name of your module. 

    !!! tip
        This name will be used for ElementaryModel, ElementaryWidgetModel, and ElementaryWidget. For example, if the name is ‘example’, the classes will be named ExampleModel, ExampleWidgetModel, and ExampleWidget.

    **5.** If you want to create a separate directory for these files inside the chosen location, check the ‘Create subdirectory’ box.

    !!! success
        After these steps, ElementaryModel, ElementaryWidgetModel, and ElementaryWidget are created and prepared for you.

    !!! bug
        IntelliJ IDEAs sometimes has a bug where created files are not displayed in the project immediately. Try collapsing and expanding the directory in the Project tab or use ‘Open in Finder/Explorer’.

=== "Plugin for VSCode"

    **1.** Choose the location where the ElementaryModel, ElementaryWidgetModel, and ElementaryWidget will be located.

    **2.** Open the Context Menu on that dirrectory.

    **3.** Select 'Generate Elementary Module'.

    **4.** Enter the name of your module. 

    !!! tip
        This name will be used for ElementaryModel, ElementaryWidgetModel, and ElementaryWidget. For example, if the name is ‘example’, the classes will be named ExampleModel, ExampleWidgetModel, and ExampleWidget.

    **5.** If you want to create a separate directory for these files  inside chosen location, choose ‘Yes’ in the next dialog.

    !!! success
        After these steps, ElementaryModel, ElementaryWidgetModel, and ElementaryWidget are created and prepared for you.

=== "Elementary brick"
 
    **1.** Run:

    ```
    mason make elementary
    ``` 

    **2.** Enter the name of your module. 

    !!! tip
        This name will be used for ElementaryModel, ElementaryWidgetModel, and ElementaryWidget. For example, if the name is ‘example’, the classes will be named ExampleModel, ExampleWidgetModel, and ExampleWidget.


    **3.**  Enter a suffix for WidgetModel, for example, _'WidgetModel'_ or _'Wm'_.

    !!! success
        After these steps, ElementaryModel, ElementaryWidgetModel, and ElementaryWidget are created and prepared for you.

=== "Elementary cli"

    **1.** In the console, navigate to the location where you want to create ElementaryModel, ElementaryWidgetModel, and ElementaryWidget. 

    !!! note
        Otherwise, you have to set the ‘root path’ parameter for the ‘generate’ command to define the path.
   
    **2.** Run:

    ``` 
    elementary_tools generate module -n {==[name]==} -p {==[root path]==} -s
    ``` 

    where

    {==[name]==} is the name of your module, for example, _'TestScreen'_,

    {==[root path]==} - path where ElementaryModel, ElementaryWidgetModel, and ElementaryWidget should be located (optional).

    !!! success
        After these steps, ElementaryModel, ElementaryWidgetModel, and ElementaryWidget are created and prepared for you.

=== "Manual creation"
    
    **1.** Choose the location where the ElementaryModel, ElementaryWidgetModel, and ElementaryWidget will be located.
    
    **2.** Create files for  ElementaryModel, ElementaryWidgetModel, and ElementaryWidget.
    
    **3.** First, create the ElementaryModel in its designated file.
    
    ``` dart
    import 'package:elementary/elementary.dart';
    
    class ExampleModel extends ElementaryModel {
        ExampleModel();
    }
    ```
    
    **4.** Then, create the interface for WidgetModel in its designated file.
    
    ``` dart
    abstract interface class IExampleWidgetModel implements IWidgetModel {}
    ```
    
    **5.** Now, create the ElementaryWidget in its designated file.
    
    ``` dart
    import 'package:elementary/elementary.dart';
    import 'package:flutter/material.dart';
    import 'example_wm.dart';
    
    class ExampleWidget extends ElementaryWidget<IExampleWidgetModel> {
      const ExampleWidget({
        Key? key,
        WidgetModelFactory wmFactory = defaultExampleWidgetModelFactory,
      }) : super(wmFactory, key: key);
    
      @override
      Widget build(IExampleWidgetModel wm) {
        return Placeholder();
      }
    }
    ``` 
    
    **6.** Now your widget requires a wmFactory, so you can proceed to create the WidgetModel and the default factory for it. Create it in the same file where you created the interface.
    
    ``` dart
    import 'package:elementary/elementary.dart';
    import 'package:flutter/material.dart';
    import 'example_model.dart';
    import 'example_widget.dart';
    
    abstract interface class IExampleWidgetModel implements IWidgetModel {
    }
    
    ExampleWidgetModel defaultExampleWidgetModelFactory(BuildContext context) {
      final errorHandler = DefaultDebugErrorHandler();
      final model = ExampleModel(errorHandler);
      return ExampleWidgetModel(model);
    }
    
    class ExampleWidgetModel extends WidgetModel<ExampleWidget, ExampleModel>
        implements IExampleWidgetModel {
    
      ExampleWidgetModel(ExampleModel model) : super(model);
    }
    ``` 
    !!! success
        After these steps you can start with implementation.

### ElementaryModel:

Open the created file to ElementaryModel and implement all the business logic in a free style. It can be a work in place with a business domain model, operating with a repository, or proxying to a responsible service, or use-case, etc.

We'll take as a reference a simple ElementaryModel, that fetches data using a repository directly. In this model we
create a method to load data. Inside the method, we catch exceptions and call `handleError` to track a problem with the error handler and notify the widget model about it (can be helpful for centralize logic of showing snack bars, etc). Rethrow the caught exception to handle it finally at the WidgetModel level.

```dart
class CountryListScreenModel extends ElementaryModel {
  final ICountryRepository _countryRepository;

  CountryListScreenModel(
    this._countryRepository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  Future<List<Country>> loadCountries() async {
    try {
      final res = await _countryRepository.loadAllCountries();
      return res;
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
```

## WidgetModel:

Open the created file to WidgetModel and implement all presentation logic and connect it with ElementaryModel.

As a sample, we will take a widget model that simply loads data using the model on start, and shows a snack bar in case of connectivity issues. For managing the state of the loading list of countries we will use a publisher, provided by `elementary_helper` package. We create a private field inside the WidgetModel to store and manage this state and provide access via the `countryListState` getter. At start, use the `initWidgetModel` lifecycle method to initiate loading without waiting for the result. The `_loadCountryList` set the state of this data to loading, and call to the model for get data, waiting for result. If the loading finishes successfully, we set a content status for `countryListState` by providing the loaded data. If the loading finishes with an error, we set an error status for `countryListState` by providing information about the error. Every time when the model calls `handleError` the `onErrorHandle` calls. If error that we get is related to connectivity problems, we show a snack bar.

```dart
class CountryListScreenWidgetModel
    extends WidgetModel<CountryListScreen, CountryListScreenModel>
    implements ICountryListWidgetModel {
  final ScaffoldMessengerWrapper _scaffoldMessengerWrapper;

  final _countryListState = EntityStateNotifier<List<Country>>();

  @override
  EntityValueListenable<List<Country>> get countryListState =>
      _countryListState;

  CountryListScreenWidgetModel(
    super.model,
    this._scaffoldMessengerWrapper,
  );

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    unawaited(_loadCountryList());
  }

  @override
  void dispose() {
    _countryListState.dispose();
    
    super.dispose();
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioException &&
        (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout)) {
      _scaffoldMessengerWrapper.showSnackBar(context, 'Connection troubles');
    }
  }

  Future<void> _loadCountryList() async {
    final previousData = _countryListState.value.data;
    _countryListState.loading(previousData);

    try {
      final res = await model.loadCountries();
      _countryListState.content(res);
    } on Exception catch (e) {
      _countryListState.error(e, previousData);
    }
  }
}
```

## ElementaryWidget:

Open the created file to ElementaryWidget and describe what the user should see based on the state of the WidgetModel. This is the easiest part, just accurately describe the screen, wrapping parts of it with builders that should react to changes in status.

```dart
class CountryListScreen extends ElementaryWidget<ICountryListWidgetModel> {
  const CountryListScreen({
    Key? key,
    WidgetModelFactory wmFactory = countryListScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ICountryListWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country list'),
      ),
      body: EntityStateNotifierBuilder<Iterable<Country>>(
        listenableEntityState: wm.countryListState,
        loadingBuilder: (_, __) => const _LoadingWidget(),
        errorBuilder: (_, __, ___) => const _ErrorWidget(),
        builder: (_, countries) => _CountryList(
          countries: countries,
        ),
      ),
    );
  }
}
```
