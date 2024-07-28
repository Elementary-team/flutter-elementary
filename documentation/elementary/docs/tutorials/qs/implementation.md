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

Implement all business logic for current feature in model, free style. 

TODO: more details, examples.

## WidgetModel:

Implement all presentation logic for current feature in widget model.

TODO: more details, examples.

## ElementaryWidget:

Based on the contract of Widget Model, describe UI.

TODO: more details, examples.