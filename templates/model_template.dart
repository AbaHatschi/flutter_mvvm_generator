import 'package:json_database/json_database.dart';

/// {{name}} Model for the application
class {{name}} implements DatabaseModel {
  @override
  int? id;
  
  // TODO: Add your fields here
  String name;
  
  {{name}}({
    this.id,
    required this.name,
  });
  
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    // TODO: Add your fields to JSON
  };
  
  /// Factory for JSON creation
  factory {{name}}.fromJson(Map<String, dynamic> json) => {{name}}(
    id: json['id'] as int?,
    name: json['name'] as String,
    // TODO: Add your fields from JSON
  );
  
  /// Copy method for updates
  {{name}} copyWith({
    int? id,
    String? name,
    // TODO: Add your fields for copyWith
  }) => {{name}}(
    id: id ?? this.id,
    name: name ?? this.name,
    // TODO: Add your fields to copyWith
  );
  
  @override
  String toString() => '{{name}}(id: $id, name: $name)';
}
