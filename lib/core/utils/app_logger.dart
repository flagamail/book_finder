import 'package:logger/logger.dart';

final Logger appLogger = Logger(
  printer: PrettyPrinter(
    errorMethodCount: 5, // number of method calls if stacktrace is provided
    lineLength: 120, // width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
  ),
);
