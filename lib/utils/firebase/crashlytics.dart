import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> setCrashlyticsCustomKey(String key, dynamic value) async {
  await FirebaseCrashlytics.instance.setCustomKey(key, value is Map?value.toString():value);
}
