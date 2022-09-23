// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      // ignore: no_default_cases
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCJ10GJTnew96B0Ww02DVX62fyRJqceOzs',
    appId: '1:709816759828:web:64e2a45c9e0aaafe401901',
    messagingSenderId: '709816759828',
    projectId: 'app-kala',
    authDomain: 'app-kala.firebaseapp.com',
    storageBucket: 'app-kala.appspot.com',
    measurementId: 'G-9W3CE7JZ9B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCoNY_JbJyDe31jSzPeFlAhAHXT75DjrE',
    appId: '1:709816759828:android:f1e954a7ae9176d3401901',
    messagingSenderId: '709816759828',
    projectId: 'app-kala',
    storageBucket: 'app-kala.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqcA5KoeIcLR7pUEv7SkUOBiMw4HC1JW8',
    appId: '1:709816759828:ios:82e305cf268106f2401901',
    messagingSenderId: '709816759828',
    projectId: 'app-kala',
    storageBucket: 'app-kala.appspot.com',
    androidClientId:
        '709816759828-gv3mu2491jn23dcb22bo8gf5rue6lmbl.apps.googleuserart.com',
    iosClientId:
        '709816759828-5im6bfm7ui6s03big28m1oin8k1jgm9u.apps.googleuserart.com',
    iosBundleId: 'kala.app',
  );
}
