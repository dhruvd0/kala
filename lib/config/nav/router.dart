import 'package:flutter/material.dart';
import 'package:kala/auth/widgets/auth_page.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/startup/splash.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (context) {
      String route = settings.name as String;
      switch (route) {
        case Routes.splash:
          return const Splash();
        case Routes.auth:
          return const AuthPage();
        default:
          return const Splash();
      }
    },
  );
}
