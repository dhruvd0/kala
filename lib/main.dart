import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/figma/consts.dart';
import 'package:kala/config/nav/router.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/startup/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          return MaterialApp(
            theme: lightTheme,
            onGenerateRoute: onGenerateRoute,
            home: Splash(),
          );
        });
  }
}
