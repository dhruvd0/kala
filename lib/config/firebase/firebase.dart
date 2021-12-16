import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConfig {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  FirebaseConfig({
    required this.firestore,
    required this.auth,
  });
 

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
