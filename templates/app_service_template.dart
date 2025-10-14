import 'package:flutter/material.dart';

import 'database_service.dart';
import 'logger_service.dart';
import 'navigation_service.dart';

/// Central service container for dependency injection
/// Manages all core services and provides them to ViewModels
/// Singleton pattern ensures consistent service instances throughout the app
class AppService {
  AppService._();
  static AppService? _instance;
  static AppService get instance => _instance ??= AppService._();

  // Core Services - initialized once
  late final NavigationService navigationService;
  late final DatabaseService databaseService;
  late final LoggerService loggerService;

  bool _isInitialized = false;

  /// Initializes all core services
  /// Call this method once at app startup (typically in main.dart)
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    // Initialize services in correct order
    loggerService = LoggerService.instance;
    await loggerService.initialize(
      enableAutoUiMessages:
          true, // Enable automatic UI messages for warnings/errors
    );

    databaseService = DatabaseService.instance;
    await databaseService.initialize();

    navigationService = NavigationService();

    _isInitialized = true;
    loggerService.success('✅ AppService initialized - All services ready');
  }

  /// Sets the UI context for services that need it (call from main widget)
  void setUiContext(BuildContext context) {
    loggerService.setUiContext(context);
  }

  /// Closes all services (useful for testing or app shutdown)
  Future<void> close() async {
    if (_isInitialized) {
      try {
        await databaseService.close();
        await loggerService.close();
        _isInitialized = false;
        // Note: Logger is closed, so we can't log the success here
      } catch (error, stackTrace) {
        // Try to log error before closing logger (if still available)
        loggerService.error(
          'Error during AppService shutdown',
          error: error,
          stackTrace: stackTrace,
          source: 'AppService',
        );
        rethrow;
      }
    }
  }

  /// Checks if all services are initialized
  bool get isInitialized => _isInitialized;

  // ViewModel Factory Methods

  // Add your ViewModel creation methods here, injecting the required services
  // HomeViewModel makeHomeViewModel() => HomeViewModel(
  //   navigationService: navigationService,
  //   databaseService: databaseService,
  //   loggerService: loggerService,
  // );
}
