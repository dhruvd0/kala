import 'package:flutter/material.dart';
import 'package:kala/config/nav/router.dart';
import 'package:kala/startup/splash.dart';

void main() {
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
    return const MaterialApp(
      onGenerateRoute: onGenerateRoute,
      home:  Splash(),
    );
  }
}
