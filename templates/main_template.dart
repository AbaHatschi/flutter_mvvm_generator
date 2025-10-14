import 'package:flutter/material.dart';

import 'src/main_app.dart';
import 'src/services/app_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all core services through AppService
  await AppService.instance.initialize();

  runApp(const MainApp());
}
