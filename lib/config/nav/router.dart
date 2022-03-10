import 'package:flutter/material.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/dashboard/widgets/dashboard_page.dart';
import 'package:kala/startup/splash.dart';

class NavigationController {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      builder: (context) {
        final route = settings.name.toString();
        return getWidgetFromRoute(route);
      },
    );
  }

  static Widget getWidgetFromRoute(String route) {
    switch (route) {
      case Routes.splash:
        return const Splash();
      // case Routes.auth:
      //   return const AuthPage();
      case Routes.dashboard:
        return const Dashboard();
      default:
        return const Splash();
    }
  }
}
