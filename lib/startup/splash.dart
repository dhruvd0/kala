import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/features/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/features/gallery/bloc/gallery_slide_bloc.dart';
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
    streamSubscription =
        firebaseConfig?.auth.userChanges().listen(handleUseAuthState);
    super.initState();
  }

  Future<void> handleUseAuthState(
    User? user,
  ) async {
    if (user == null) {
      await Navigator.pushReplacementNamed(context, Routes.auth);
    } else {
      await authenticatePageRoutine();
    }
    await streamSubscription?.cancel();
  }

  Future<void> authenticatePageRoutine() async {
    final galleryBloc = BlocProvider.of<GalleryBloc>(context);
    await Future.doWhile(() {
      final isUserContentInitialized =
          galleryBloc.state.contentSlideList.isNotEmpty &&
              BlocProvider.of<KalaUserContentBloc>(context).state.userContent !=
                  null;
      return isUserContentInitialized;
    });
    if (mounted) {
      // ignore: use_build_context_synchronously
      await Navigator.pushReplacementNamed(context, Routes.dashboard);
    }
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
