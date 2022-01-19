import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/artist_page/widgets/artist_page.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/figma/consts.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/config/nav/router.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/dashboard/bloc/dash_controller.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';

import 'package:kala/startup/splash.dart';
import 'firebase_options.dart';

FirebaseConfig? firebaseConfig;
// ignore: non_constant_identifier_names
bool TEST_FLAG = false;
void main({FirebaseConfig? mockFirebase}) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (mockFirebase == null) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseConfig = FirebaseConfig(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );
  } else {
    firebaseConfig = mockFirebase;
    TEST_FLAG = true;
  }

  runApp(const KalaApp());
}

class KalaApp extends StatefulWidget {
  const KalaApp({Key? key}) : super(key: key);

  @override
  _KalaAppState createState() => _KalaAppState();
}

class _KalaAppState extends State<KalaApp> {
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
            title: "Kala",
            theme: lightTheme,
            builder: (context, widget) {
              ScreenUtil.setContext(context);

              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
            onGenerateRoute: NavigatorController.onGenerateRoute,
            home: const ArtistPage(),
          ),
        );
      },
    );
  }
}
