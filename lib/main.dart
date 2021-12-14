import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/widgets/auth_page.dart';
import 'package:kala/config/figma/consts.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/config/nav/router.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/startup/splash.dart';

FirebaseConfig? firebaseConfig;
void main({FirebaseConfig? mockFirebase}) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (mockFirebase == null) {
    await Firebase.initializeApp();
    firebaseConfig = FirebaseConfig(
      firebaseAuthInstance: FirebaseAuth.instance,
      firestoreInstance: FirebaseFirestore.instance,
    );
  } else {
    firebaseConfig = mockFirebase;
  }
  runApp(
    const MaterialApp(
      home: KalaApp(),
    ),
  );
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
              home: const AuthPage(),
            ),
          );
        });
  }
}
