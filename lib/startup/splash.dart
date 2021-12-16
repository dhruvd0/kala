import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/widgets/buttons/curved_mono_button.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

/// The first widget to display for Kala App
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void dispose() {
    if (mounted) {
      super.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      String nextRoute = "";
      var currentUser2 = firebaseConfig?.auth.currentUser;
      if (currentUser2 == null) {
        nextRoute = Routes.auth;
      } else {
        BlocProvider.of<KalaUserBloc>(context, listen: false)
            .userSnapshotFetcher();
      }
      if (nextRoute.isNotEmpty) {
        Navigator.pushReplacementNamed(context, nextRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 300),
            Text(
              "K",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            RectMonoButton(
                text: "Sign Out",
                onTap: () {
                  firebaseConfig?.auth.signOut();
                  Navigator.pushNamed(context, Routes.auth);
                })
          ],
        ),
      ),
    );
  }
}
