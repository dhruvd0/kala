import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseConfig {
  FirebaseConfig({
    required this.auth,
    required this.firestore,
    required this.remoteConfig,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final RemoteConfig remoteConfig;

  FirebaseConfig copyWith({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    RemoteConfig? remoteConfig,
  }) {
    return FirebaseConfig(
      auth: auth ?? this.auth,
      firestore: firestore ?? this.firestore,
      remoteConfig: remoteConfig ?? this.remoteConfig,
    );
  }
}
