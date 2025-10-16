import 'package:json_database/json_database.dart';

import '../models/{{name_snake}}.dart';
import '../services/logger_service.dart';

/// Repository for {{name}} management
/// Inherits from BaseRepository and implements specific {{name}} logic
class {{name}}Repository extends BaseRepository<{{name}}> {
  {{name}}Repository() : super('{{name_snake}}s', databaseName: 'app_database') {
    try {
      final int existingCount = count();
      LoggerService.instance.info(
        '{{name}}Repository initialized successfully',
        source: '{{name}}Repository',
        data: <String, Object?>{
          'tableName': '{{name_snake}}s',
          'existingRecords': existingCount,
        },
      );
    } catch (error, stackTrace) {
      LoggerService.instance.error(
        'Failed to initialize {{name}}Repository',
        error: error,
        stackTrace: stackTrace,
        source: '{{name}}Repository',
      );
      rethrow;
    }
  }
  
  @override
  {{name}} fromJson(Map<String, dynamic> json) => {{name}}.fromJson(json);
  
  //? Specific {{name}} methods or
  //? Add more specific methods for {{name}}
  
  /// Search {{name}} for name
  {{name}}? findByName(String name) {
    return findFirst(<String, dynamic>{'name': name});
  }
  
  /// Searches all {{name}}s for conditions
  List<{{name}}> findBy{{name}}Criteria(String criteria) {
    return searchByField('name', criteria);
  }
  
  /// Checks whether name already exists
  bool nameExists(String name) {
    return exists(<String, dynamic>{'name': name});
  }  
}
