import 'package:json_database/json_database.dart';

import '../models/{{name_snake}}.dart';

/// Repository for {{name}} management
/// Inherits from BaseRepository and implements specific {{name}} logic
class {{name}}Repository extends BaseRepository<{{name}}> {
  {{name}}Repository() : super('{{name_snake}}s', databaseName: 'app_database') {
    try {
      DatabaseEngine.instance.initialize(databaseName: '{{name_snake}}s');
      Logger.instance.info(
        '{{name}} model registered in database',
        source: '{{name}}Repository',
      );
    } catch (error, stackTrace) {
      Logger.instance.error(
        'Failed to register {{name}} model in database',
        error: error,
        stackTrace: stackTrace,
        source: '{{name}}Repository',
      );
    }
  }
  
  @override
  {{name}} fromJson(Map<String, dynamic> json) => {{name}}.fromJson(json);
  
  // Specific {{name}} methods
  
  /// Search {{name}} for name
  {{name}}? findByName(String name) {
    return findFirst({'name': name});
  }
  
  /// Searches all {{name}}s for conditions
  List<{{name}}> findBy{{name}}Criteria(String criteria) {
    return searchByField('name', criteria);
  }
  
  /// Checks whether name already exists
  bool nameExists(String name) {
    return exists({'name': name});
  }
  
  // TODO: Add more specific methods for {{name}}
}