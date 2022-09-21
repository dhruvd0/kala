import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:kala/config/firebase/firebase.dart';

final getIt = GetIt.instance;
FirebaseConfig get firebaseConfig => getIt.get<FirebaseConfig>();
Future<void> injectDependencies() async {
  getIt.registerSingleton(await setupFirebase());
}

Future<FirebaseConfig> setupFirebase() async {
  return FirebaseConfig(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    remoteConfig: FirebaseRemoteConfig.instance,
    storage: FirebaseStorage.instance,
  );
}
