## Create classes:

Using a chosen tool create classes for ElementaryModel, WidgetModel, ElementaryWidget.

=== "Plugin for IntelliJ"

    To create an Elementary Module using the Elementary Plugin for IntelliJ follow the next steps:
    **1.** Choose the location where the Elementary module will be located.

    **2.** Open the Context Menu.

    **3.** Click 'New'.

    **4.** Select 'Elementary Module'.

    **5.** Enter the name of your module.

    **6.** If you want to create a separate directory for these files check the 'Create subdirectory' box.

    This will create three required template files for ElementaryModel, ElementaryWidgetModel, and ElementaryWidget.

=== "Plugin for VSCode"


    To create an Elementary Module open the Context Menu
    at the location where you want to create the Module, select 'Generate Elementary Module'
    and enter the name of your module.

    This will create three required template files for ElementaryModel, ElementaryWidgetModel, and ElementaryWidget.


=== "Elementary brick"

    **If you don't have [Mason](https://pub.dev/packages/mason_cli) installed, you need to install it by running the command:**

    ```
    dart pub global activate mason_cli
    ```

    The next step is to initialize Mason, run:

    ```
    mason init
    ```
    Then install Elementary by running the command:

    _Install locally_
    ```
    mason add elementary
    ```
    _Install globally_

    ```
    mason add -g elementary
    ```


=== "Elementary cli"

    **To direct usage run**

    ```
    dart pub global activate elementary_cli  
    ``` 
    or

    ```
    flutter pub global activate elementary_cli
    ```

    **To use [elementary_cli](https://pub.dev/packages/elementary_cli) as a library in the pubspec.yaml file add**
    ```
    dependencies:
        elementary_cli: $actual_version
    ```

    **or run:**

    With Dart:

    ```
    dart pub add elementary_cli
    ```

    With Flutter:

    ```
    flutter pub add elementary_cli
    ```

    After this run:

    ```
    flutter pub get
    ```


TODO: describe manual creation.

### ElementaryModel:

Implement all business logic for current feature in model, free style. 

TODO: more details, examples.

## WidgetModel:

Implement all presentation logic for current feature in widget model.

TODO: more details, examples.

## ElementaryWidget:

Based on the contract of Widget Model, describe UI.

TODO: more details, examples.