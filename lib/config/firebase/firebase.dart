import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConfig {
  FirebaseConfig({
    required this.firestore,
    required this.auth,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseConfig copyWith({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) {
    return FirebaseConfig(
      firestore: firestore ?? this.firestore,
      auth: auth ?? this.auth,
    );
  }
}
