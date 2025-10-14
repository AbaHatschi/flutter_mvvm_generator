import 'package:flutter_mvvm_core/flutter_mvvm_core.dart';
import 'package:json_database/json_database.dart';

/// Database service for dependency injection
/// Initializes the database and provides repositories
class DatabaseService {
  DatabaseService._();
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();

  bool _isInitialized = false;

  // Repositories
  //? Repositories will be added here

  /// Initializes the database and all repositories
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      // Database Engine initialize
      await DatabaseEngine.instance.initialize(databaseName: 'app_database');

      // Repositories initialize
      //? Repositories will be initialized here
      // modelNameRepository = ModelNameRepository();

      _isInitialized = true;
      Logger.instance.success(
        'Database Service successfully initialized',
        source: 'DatabaseService',
        data: <String, Object?>{
          'databaseName': 'app_database',
          'repositoriesCount': 1,
        },
      );
    } catch (error, stackTrace) {
      Logger.instance.error(
        'Failed to initialize Database Service',
        error: error,
        stackTrace: stackTrace,
        source: 'DatabaseService',
      );
      rethrow;
    }
  }

  /// Closes the database
  Future<void> close() async {
    if (_isInitialized) {
      try {
        await DatabaseEngine.instance.close(databaseName: 'app_database');
        _isInitialized = false;
        Logger.instance.info(
          'Database Service successfully closed',
          source: 'DatabaseService',
          data: <String, Object?>{'databaseName': 'app_database'},
        );
      } catch (error, stackTrace) {
        Logger.instance.error(
          'Error closing Database Service',
          error: error,
          stackTrace: stackTrace,
          source: 'DatabaseService',
        );
        _isInitialized = false; // Reset state even on error
        rethrow;
      }
    }
  }

  /// Checks if the database is initialized
  bool get isInitialized => _isInitialized;
}
