import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

/// The first widget to display for Kala App
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  StreamSubscription? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      streamSubscription =
          firebaseConfig?.auth.userChanges().listen(handleUseAuthState);
    });
  }

  Future<Widget> handleUseAuthState(
    User? user,
  ) async {
    var nextRoute = '';

    if (user == null) {
      nextRoute = Routes.auth;
    } else {
      await Future.doWhile(() {
        final isDataLoaded = BlocProvider.of<GalleryBloc>(context, listen: false)
                .state
                .contentSlideList
                .isNotEmpty &&
            BlocProvider.of<KalaUserContentBloc>(context, listen: false)
                    .state
                    .userContent !=
                null;
        return isDataLoaded;
      });

      nextRoute = Routes.dashboard;
    }
    if (mounted) {
      await Navigator.pushReplacementNamed(context, nextRoute);
    }
    return const LogoSplash();
  }

  @override
  Widget build(BuildContext context) {
    return const LogoSplash();
  }
}

class LogoSplash extends StatelessWidget {
  const LogoSplash({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      scaffoldKey: const ValueKey(ScaffoldKeys.splashKey),
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              top: 280.h,
              child: Text(
                'Kala',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 64.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
