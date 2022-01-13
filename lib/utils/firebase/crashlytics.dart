import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

Future<void> setCrashlyticsCustomKey(String key, dynamic value) async {
  if (Firebase.apps.isEmpty) {
    return;
  }
  if (kIsWeb) {
    return;
  }
  await FirebaseCrashlytics.instance
      .setCustomKey(key, value is Map ? value.toString() : value);
}
