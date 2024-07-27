# Choose tooling:

To make work with library more convenient and automate classes creation, boilerplate code, etc.,
you can use one of this tools, otherwise you have to do all dirty work manually:

- [plugin for IntelliJ](https://plugins.jetbrains.com/plugin/18099-elementary)
- [plugin for VSCode](https://marketplace.visualstudio.com/items?itemName=ElementaryTeam.elementary)
- [elementary brick](https://brickhub.dev/bricks/elementary)
- [elementary_cli](https://pub.dev/packages/elementary_cli)

Depends on your IDE and personal preferences choose one of the ways:

=== "Plugin for IntelliJ"
   
     **Install plugin from Marketplace:**

    **1.** Open settings and then select Plugins.

    **2.** Click the Marketplace tab and type 'Elementary' in the search field.

    **3.** To install the plugin, click Install and restart IntelliJ IDEA.

=== "Plugin for VSCode"

    **Install Elementary extensions from Extension Marketplace:**

    **1.** Bring up the Extensions view by clicking on the Extensions icon in
       the Activity Bar on the side of VS Code or the View: Extensions command (⇧⌘X).

    **2.** Type 'Elementary' in the search field.

    **3.** To install the plugin, click Install


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
