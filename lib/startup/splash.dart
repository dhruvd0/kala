import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/social_integration/auth_types.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/config/nav/router.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

/// The first widget to display for Kala App
class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      body: StreamBuilder<User?>(
          stream: firebaseConfig?.auth.userChanges(),
          builder: (context, userSnapshot) {
            return handleUseAuthState(userSnapshot, context);
          }),
    );
  }

  Widget handleUseAuthState(AsyncSnapshot<User?> userSnapshot, context) {
    if (!userSnapshot.hasData) {
      return LogoSplash();
    }

    String nextRoute = "";
    User? user = userSnapshot.data;
    if (user == null) {
      nextRoute = Routes.auth;
    } else {
      if (TEST_FLAG) {
        BlocProvider.of<KalaUserBloc>(context, listen: false)
            .authenticateWithSocialAuth(AuthTypes.google);
      }
      nextRoute = Routes.gallery;
    }
    return NavigatorController.getWidgetFromRoute(nextRoute);
  }
}

class LogoSplash extends StatelessWidget {
  const LogoSplash({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "K",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
