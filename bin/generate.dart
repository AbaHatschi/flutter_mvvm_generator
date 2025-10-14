import 'dart:io';

import 'package:path/path.dart' as path;

void main(List<String> args) {
  if (args.isEmpty) {
    stdout.writeln('Usage: dart run bin/generate.dart <command> [Name]');
    stdout.writeln('Commands:');
    stdout.writeln('  view <Name>     - Generate view and view model');
    stdout.writeln('  model <Name>    - Generate model and repository');
    stdout.writeln('  router          - Generate app router and route names');
    stdout.writeln('  service         - Generate core services');
    stdout.writeln(
      '  main            - Generate main.dart and MainApp for MVVM setup',
    );
    exit(0);
  }

  final String command = args[0];

  switch (command) {
    case 'view':
      if (args.length < 2) {
        stdout.writeln('Usage: dart run bin/generate.dart view <Name>');
        exit(0);
      }
      final String name = args[1];
      final String snake = toSnakeCase(name);

      generateFile(
        templateName: 'view_template.dart',
        outputDir: 'lib/src/ui/views',
        outputFile: '${snake}_view.dart',
        name: name,
        snake: snake,
        label: '${name}View',
      );

      generateFile(
        templateName: 'view_model_template.dart',
        outputDir: 'lib/src/ui/view_models',
        outputFile: '${snake}_view_model.dart',
        name: name,
        snake: snake,
        label: '${name}ViewModel',
      );

    case 'model':
      if (args.length < 2) {
        stdout.writeln('Usage: dart run bin/generate.dart model <Name>');
        exit(0);
      }
      final String modelName = args[1];
      final String modelSnake = toSnakeCase(modelName);

      // Generate Model
      generateFile(
        templateName: 'model_template.dart',
        outputDir: 'lib/src/models',
        outputFile: '$modelSnake.dart',
        name: modelName,
        snake: modelSnake,
        label: '$modelName Model',
      );

      // Generate Repository
      generateFile(
        templateName: 'repository_template.dart',
        outputDir: 'lib/src/repositories',
        outputFile: '${modelSnake}_repository.dart',
        name: modelName,
        snake: modelSnake,
        label: '${modelName}Repository',
      );

      // Generate DatabaseService instructions
      generateDatabaseServiceInstructions(modelName, modelSnake);

    case 'router':
      generateRouter();

    case 'service':
      generateServices();

    case 'main':
      generateMain();

    default:
      stdout.writeln('Unknown command: $command');
      exit(0);
  }
}

/// Get the correct path to the templates directory
String getTemplatePath(String templateName) {
  // Get the directory where this script is located
  final String scriptDir = path.dirname(Platform.script.toFilePath());

  // Go up one level from bin/ to the package root, then to templates/
  final String templatePath = path.join(
    path.dirname(scriptDir), // Go up from bin/ to package root
    'templates',
    templateName,
  );

  // Check if file exists
  if (!File(templatePath).existsSync()) {
    throw Exception('Template file not found: $templatePath');
  }

  return templatePath;
}

/// Converted CamelCase to snake_case
String toSnakeCase(String input) {
  return input
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (Match m) => '${m[1]}_${m[2]}',
      )
      .toLowerCase();
}

/// Converted any case to camelCase
String toCamelCase(String input) {
  final String snake = toSnakeCase(input);
  return snake.split('_').asMap().entries.map((MapEntry<int, String> entry) {
    final int i = entry.key;
    final String word = entry.value;
    if (i == 0) {
      return word; // first word small
    }
    return word[0].toUpperCase() + word.substring(1);
  }).join();
}

/// Generic file generation
void generateFile({
  required String templateName,
  required String outputDir,
  required String outputFile,
  required String name,
  required String snake,
  required String label,
}) {
  final String camel = toCamelCase(name);

  final Directory dir = Directory(outputDir);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  final File templateFile = File(getTemplatePath(templateName));
  String content = templateFile.readAsStringSync();

  content = content.replaceAll('{{name}}', name);
  content = content.replaceAll('{{name_snake}}', snake);
  content = content.replaceAll('{{name_camel}}', camel);

  File('${dir.path}/$outputFile').writeAsStringSync(content);

  stdout.writeln('✅ $label created in ${dir.path}');
}

/// Generate AppRouter and RouteName files
void generateRouter() {
  final Directory coreDir = Directory('lib/src/router');
  if (!coreDir.existsSync()) {
    coreDir.createSync(recursive: true);
  }

  // AppRouter
  final String routerTemplate = File(
    getTemplatePath('app_router_template.dart'),
  ).readAsStringSync();
  File('${coreDir.path}/app_router.dart').writeAsStringSync(routerTemplate);

  // RouteName
  final String routeNameTemplate = File(
    getTemplatePath('route_name_template.dart'),
  ).readAsStringSync();
  File('${coreDir.path}/route_name.dart').writeAsStringSync(routeNameTemplate);

  stdout.writeln('✅ AppRouter and RouteName created in ${coreDir.path}');
}

/// Generate AppService, NavigationService, DatabaseService and LoggerService files
void generateServices() {
  final Directory coreDir = Directory('lib/src/services');
  if (!coreDir.existsSync()) {
    coreDir.createSync(recursive: true);
  }

  // AppService
  final String appServiceTemplate = File(
    getTemplatePath('app_service_template.dart'),
  ).readAsStringSync();
  File(
    '${coreDir.path}/app_service.dart',
  ).writeAsStringSync(appServiceTemplate);

  // NavigationService
  final String navigationServiceTemplate = File(
    getTemplatePath('navigation_service_template.dart'),
  ).readAsStringSync();
  File(
    '${coreDir.path}/navigation_service.dart',
  ).writeAsStringSync(navigationServiceTemplate);

  // DatabaseService
  final String databaseServiceTemplate = File(
    getTemplatePath('database_service_template.dart'),
  ).readAsStringSync();

  // Replace placeholders with empty content for initial setup
  String databaseContent = databaseServiceTemplate;
  databaseContent = databaseContent.replaceAll('{{repository_imports}}', '');
  databaseContent = databaseContent.replaceAll(
    '{{repository_declarations}}',
    '// Repositories will be added here',
  );
  databaseContent = databaseContent.replaceAll(
    '{{repository_initializations}}',
    '// Repository initializations will be added here',
  );

  File(
    '${coreDir.path}/database_service.dart',
  ).writeAsStringSync(databaseContent);

  // LoggerService
  final String loggerServiceTemplate = File(
    getTemplatePath('logger_service_template.dart'),
  ).readAsStringSync();
  File(
    '${coreDir.path}/logger_service.dart',
  ).writeAsStringSync(loggerServiceTemplate);

  stdout.writeln(
    '✅ AppService, NavigationService, DatabaseService & LoggerService created in ${coreDir.path}',
  );
}

/// Generate instructions for DatabaseService integration
void generateDatabaseServiceInstructions(String modelName, String modelSnake) {
  final String modelCamel = toCamelCase(modelSnake);
  stdout.writeln();
  stdout.writeln('🔴 TODO: Add to DatabaseService manually:');
  stdout.writeln();
  stdout.writeln('1. Add import:');
  stdout.writeln("   import '../repositories/${modelSnake}_repository.dart';");
  stdout.writeln();
  stdout.writeln('2. Add repository declaration:');
  stdout.writeln(
    '   late final ${modelName}Repository ${modelCamel}Repository;',
  );
  stdout.writeln();
  stdout.writeln('3. Add to initialize() method:');
  stdout.writeln('   ${modelCamel}Repository = ${modelName}Repository();');
  stdout.writeln();
  stdout.writeln('4. Add to AppService makeViewModel methods as needed');
  stdout.writeln();
}

/// Generate main.dart and MainApp files for MVVM framework setup
void generateMain() {
  // Generate main.dart in lib/
  final String mainTemplate = File(
    getTemplatePath('main_template.dart'),
  ).readAsStringSync();
  File('lib/main.dart').writeAsStringSync(mainTemplate);

  // Generate MainApp in lib/src/
  final Directory srcDir = Directory('lib/src');
  if (!srcDir.existsSync()) {
    srcDir.createSync(recursive: true);
  }

  final String mainAppTemplate = File(
    getTemplatePath('main_app_template.dart'),
  ).readAsStringSync();
  File('${srcDir.path}/main_app.dart').writeAsStringSync(mainAppTemplate);

  // Generate analysis_options.yaml in project root
  final String analysisOptionsTemplate = File(
    getTemplatePath('analysis_options_template.dart'),
  ).readAsStringSync();
  File('analysis_options.yaml').writeAsStringSync(analysisOptionsTemplate);

  stdout.writeln('✅ main.dart created in lib/');
  stdout.writeln('✅ MainApp created in lib/src/');
  stdout.writeln('✅ analysis_options.yaml created in project root');
}
