import 'dart:io';

/// Interface for exceptions that have exit code
///
/// If exception has an exit code than it should be treated as 'critical'
/// and only be caught in `main()` function
abstract class ExitCodeException {
  int get exitCode;
}

/// Exception thrown when arguments are incorrect.
class CommandLineUsageException extends IOException
    implements ExitCodeException {

  CommandLineUsageException({
    this.message = '',
    this.argumentName = '',
    this.argumentValue = '',
  });

  final String message;
  final String argumentName;
  final String argumentValue;

  @override
  int get exitCode => 64;

  @override
  String toString() {
    if (message.isNotEmpty) {
      return message;
    }
    if (argumentValue.isNotEmpty) {
      return '"$argumentValue" is not a correct value${argumentName.isNotEmpty ? ' for $argumentName' : ''}';
    }
    if (argumentName.isNotEmpty) {
      return '"$argumentName" value is incorrect';
    }
    return 'incorrect arguments';
  }
}

/// Exception thrown when user puts non-existent folder name.
class NonExistentFolderException extends FileSystemException
    implements ExitCodeException {

  NonExistentFolderException(String folderPath)
      : super('Directory does not exist', folderPath);

  @override
  int get exitCode => 65;
}

/// Exception thrown when program cannot access template files.
class GenerateTemplatesUnreachableException extends FileSystemException
    implements ExitCodeException {

  GenerateTemplatesUnreachableException(
    String message,
  ) : super('Generator misses template files. Cause: $message');

  @override
  int get exitCode => 66;
}

/// Exception thrown when program tries to create existing file.
class GeneratorTargetFileExistsException extends FileSystemException
    implements ExitCodeException {
  GeneratorTargetFileExistsException(
    String filepath,
  ) : super('file already exists', filepath);

  @override
  int get exitCode => 67;
}

/// Exception thrown when program cannot successfully generate files.
class GenerationException extends FileSystemException
    implements ExitCodeException {

  GenerationException() : super('generation cancelled: unknown error happened');

  @override
  int get exitCode => 68;
}

/// Exception thrown when user puts non-existent folder name.
class NonExistentFileException extends FileSystemException
    implements ExitCodeException {

  NonExistentFileException(String filePath)
      : super('File does not exist', filePath);

  @override
  int get exitCode => 69;
}

/// Exception thrown when server timed out to connect.
class ServerTimeoutException implements ExitCodeException, Exception {

  ServerTimeoutException(this.message);

  final String message;

  @override
  int get exitCode => 70;

  @override
  String toString() {
    return message;
  }
}
