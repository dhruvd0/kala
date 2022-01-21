import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/figma/consts.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/config/nav/router.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/dashboard/bloc/dash_controller.dart';
import 'package:kala/firebase_options.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/startup/splash.dart';

FirebaseConfig? firebaseConfig;

bool isTestMode = true;
Future<void> main({FirebaseConfig? mockFirebase}) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await setupFirebase(mockFirebase);
      await setupCrashlytics();

      runApp(const KalaApp());
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack),
  );
}

Future<void> setupFirebase(FirebaseConfig? mockFirebase) async {
  if (mockFirebase == null) {
    isTestMode = false;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseConfig = FirebaseConfig(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );
  } else {
    firebaseConfig = mockFirebase;
    isTestMode = true;
  }
}

Future<void> setupCrashlytics() async {
  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
}

class KalaApp extends StatelessWidget {
  const KalaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        FigmaConstants.figmaScreenWidth,
        FigmaConstants.figmaScreenHeight,
      ),
      builder: () {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              lazy: false,
              create: (context) => KalaUserBloc(),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => KalaUserContentCubit(
                kalaUserBloc: context.read<KalaUserBloc>(),
              ),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => GalleryBloc(
                kalaUserBloc: context.read<KalaUserBloc>(),
              ),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => DashController(),
            ),
          ],
          child: MaterialApp(
            title: 'Kala',
            theme: lightTheme,
            builder: (context, widget) {
              ScreenUtil.setContext(context);

              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: widget!,
              );
            },
            onGenerateRoute: NavigatorController.onGenerateRoute,
            home: const Splash(),
          ),
        );
      },
    );
  }
}
