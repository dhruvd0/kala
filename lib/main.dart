import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/figma/consts.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/config/nav/router.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/startup/splash.dart';
import 'package:firebase_core/firebase_core.dart';
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

  runApp(const MaterialApp(
    home: KalaApp(),
  ));
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
                create: (context) => KalaUserBloc(),
              ),
            ],
            child: MaterialApp(
              theme: lightTheme,
              onGenerateRoute: onGenerateRoute,
              home: const Splash(),
            ),
          );
        },);
  }
}
