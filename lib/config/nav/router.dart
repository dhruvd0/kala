import 'package:flutter/material.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/startup/route_decider.dart';
import 'package:kala/startup/splash.dart';

Route<dynamic> onGenerateRoute(settings) {
  return MaterialPageRoute(
    builder: (context) {
      String route = getRouteAfterSplash();
      switch (route) {
        case Routes.splash:
          return const Splash();
        default:
          return const Splash();
      }
    },
  );
}
