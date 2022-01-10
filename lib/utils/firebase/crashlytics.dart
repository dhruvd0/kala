import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> setCrashlyticsCustomKey(String key, dynamic value) async {
  if (Firebase.apps.isEmpty) {
    return;
  }
  await FirebaseCrashlytics.instance
      .setCustomKey(key, value is Map ? value.toString() : value);
}
