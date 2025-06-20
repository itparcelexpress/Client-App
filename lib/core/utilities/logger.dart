import 'dart:developer' as developer;

class Logger {
  // Log Levels with Icons
  static const String _info = "INFO 🟢";
  static const String _warning = "WARNING 🟠";
  static const String _error = "ERROR 🔴";
  static const String _debug = "DEBUG 🟣";

  /// Logs an informational message
  static void info(String message, {String? tag}) {
    _log(_info, message, tag);
  }

  /// Logs a warning message
  static void warning(String message, {String? tag}) {
    _log(_warning, message, tag);
  }

  /// Logs an error message
  static void error(String message,
      {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log(_error, message, tag);
    if (error != null) {
      developer.log(error.toString(), level: 1000, name: tag ?? "ERROR");
    }
    if (stackTrace != null) {
      developer.log(stackTrace.toString(), level: 1000, name: tag ?? "ERROR");
    }
  }

  /// Logs a debug message
  static void debug(String message, {String? tag}) {
    _log(_debug, message, tag);
  }

  /// Helper method to format and print logs
  static void _log(String level, String message, String? tag) {
    final timeStamp = DateTime.now().toIso8601String();
    final logTag = tag ?? "Logger";
    final logMessage = "[$timeStamp][$logTag][$level]: $message";
    developer.log(logMessage, name: logTag);
  }
}
