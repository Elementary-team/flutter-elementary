# Elementary CLI
CLI utilities for Elementary

## Installation

#### For direct use CLI
Run `dart pub global activate elementary_cli` or `flutter pub global activate elementary_cli`

#### For using the Elementary plugin for VSCode
Run `dart pub global activate elementary_cli`

#### For using the Elementary plugin for Intellij
Run `flutter pub global activate elementary_cli`

## Using

#### Creating an Elementary Module with CLI
Run `elementary_tools generate module -n [name] -p [root path] -s`

## Integration
The only option for now is exit codes. You can find a full list of exceptions and exit codes
in [exit_code_exception.dart](lib/exit_code_exception.dart) file.
