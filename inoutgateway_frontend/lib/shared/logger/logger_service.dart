import 'dart:developer';

enum LogLevel { info, warning, error }

class LoggerService {
  static void log_(String message, {LogLevel level = LogLevel.info}) {
    final timestamp = DateTime.now().toIso8601String();
    final levelTag = level.toString().split('.').last; // Extracts INFO, WARNING, ERROR

    final logMessage = "[$timestamp] [$levelTag] $message";

    // Use Dart's developer log (can be seen in Flutter DevTools)
    log(logMessage, name: "INOUTGATEWAY_LOG");

    // TODO: Optionally save logs to a file or send them to a backend server.
  }
}
