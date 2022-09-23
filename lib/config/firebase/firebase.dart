import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseConfig {
  FirebaseConfig({
    required this.auth,
    required this.firestore,
    required this.remoteConfig,
    required this.storage,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseRemoteConfig remoteConfig;
  final FirebaseStorage storage;
  

  FirebaseConfig copyWith({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseRemoteConfig? remoteConfig,
    FirebaseStorage? storage,
  }) {
    return FirebaseConfig(
      auth: auth ?? this.auth,
      firestore: firestore ?? this.firestore,
      remoteConfig: remoteConfig ?? this.remoteConfig,
      storage: storage ?? this.storage,
    );
  }
}
