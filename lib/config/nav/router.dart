import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/features/auth/widgets/auth_page.dart';
import 'package:kala/features/dashboard/widgets/dashboard_page.dart';
import 'package:kala/features/gallery/art/art_page/widgets/content_page.dart';
import 'package:kala/features/gallery/art/bloc/art_bloc.dart';
import 'package:kala/startup/splash.dart';

class NavigationController {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      builder: (context) {
        final route = settings.name.toString();
        final bloc = settings.arguments;

        return getWidgetFromRoute(route, bloc: bloc);
      },
    );
  }

  static Widget getWidgetFromRoute(String route, {dynamic bloc}) {
    switch (route) {
      case Routes.splash:
        return const Splash();
      case Routes.auth:
        return const AuthPage();
      case Routes.dashboard:
        return const Dashboard();
      case Routes.artPage:
        assert(bloc is ArtBloc);
        return BlocProvider<ArtBloc>.value(
          value: bloc,
          child: const ArtPage(),
        );
      default:
        return const Splash();
    }
  }
}
