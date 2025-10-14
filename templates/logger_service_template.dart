import 'package:flutter/material.dart';
import 'package:flutter_mvvm_core/flutter_mvvm_core.dart';

/// Logger service for dependency injection and UI integration
/// Provides centralized logging with optional UI message display
class LoggerService {
  LoggerService._();
  static LoggerService? _instance;
  static LoggerService get instance => _instance ??= LoggerService._();

  bool _isInitialized = false;

  /// Initializes the logger service
  Future<void> initialize({
    LogLevel minimumLevel = LogLevel.info,
    bool enableConsoleOutput = true,
    bool enableAutoUiMessages = false,
    LogLevel autoUiMessageLevel = LogLevel.warning,
  }) async {
    if (_isInitialized) {
      return;
    }

    // Configure main logger
    Logger.instance.setMinimumLevel(minimumLevel);
    Logger.instance.printToConsole = enableConsoleOutput;

    // Configure UI logger if requested
    if (enableAutoUiMessages) {
      UiLogger.instance.setAutoMessages(true, minimumLevel: autoUiMessageLevel);
    }

    _isInitialized = true;
    Logger.instance.success('✅ Logger Service initialized successfully');
  }

  /// Sets the current BuildContext for UI messages
  // ignore: use_setters_to_change_properties
  void setUiContext(BuildContext? context) {
    UiLogger.instance.uiContext = context;
  }

  /// Quick access to main logger
  Logger get logger => Logger.instance;

  /// Quick access to UI logger
  UiLogger get ui => UiLogger.instance;

  /// Convenience methods that delegate to the main logger

  void debug(String message, {String? source, Map<String, Object?>? data}) {
    Logger.instance.debug(message, source: source, data: data);
  }

  void info(String message, {String? source, Map<String, Object?>? data}) {
    Logger.instance.info(message, source: source, data: data);
  }

  void success(String message, {String? source, Map<String, Object?>? data}) {
    Logger.instance.success(message, source: source, data: data);
  }

  void warning(
    String message, {
    Object? error,
    String? source,
    Map<String, Object?>? data,
  }) {
    Logger.instance.warning(message, error: error, source: source, data: data);
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? source,
    Map<String, Object?>? data,
  }) {
    Logger.instance.error(
      message,
      error: error,
      stackTrace: stackTrace,
      source: source,
      data: data,
    );
  }

  void critical(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? source,
    Map<String, Object?>? data,
  }) {
    Logger.instance.critical(
      message,
      error: error,
      stackTrace: stackTrace,
      source: source,
      data: data,
    );
  }

  /// Logs the result of a Future operation
  Future<T> logFuture<T>(
    String operationName,
    Future<T> future, {
    String? source,
    Map<String, Object?>? data,
  }) {
    return Logger.instance.logFuture(
      operationName,
      future,
      source: source,
      data: data,
    );
  }

  /// Gets recent log entries for debugging
  List<LogEntry> getRecentLogs({LogLevel? minimumLevel}) {
    return Logger.instance.getRecentLogs(minimumLevel: minimumLevel);
  }

  /// Clears recent logs
  void clearLogs() {
    Logger.instance.clearRecentLogs();
  }

  /// Closes the logger service
  Future<void> close() async {
    if (_isInitialized) {
      try {
        await Logger.instance.close();
        _isInitialized = false;
      } catch (error, stackTrace) {
        Logger.instance.error(
          'Error closing Logger Service',
          error: error,
          stackTrace: stackTrace,
          source: 'LoggerService',
        );
        _isInitialized = false; // Reset state even on error
        rethrow;
      }
    }
  }

  /// Checks if the service is initialized
  bool get isInitialized => _isInitialized;
}
