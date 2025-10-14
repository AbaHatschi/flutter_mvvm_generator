import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'router/route_name.dart';
import 'services/app_service.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set UI context for services that need it
    AppService.instance.setUiContext(context);

    final AppRouter router = AppRouter();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MainApp',
      navigatorKey: AppService.instance.navigationService.navigatorKey,
      initialRoute: RouteName.home,
      onGenerateRoute: router.generateRoute,
    );
  }
}
