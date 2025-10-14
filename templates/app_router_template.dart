import 'package:flutter/material.dart';

import '../services/app_service.dart';
import 'route_name.dart';

class AppRouter {
  AppRouter();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case RouteName.home:
      //   return MaterialPageRoute<dynamic>(
      //     builder: (_) =>
      //         HomeView(homeViewModel: AppService.instance.makeHomeViewModel()),
      //   );

      default:
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
