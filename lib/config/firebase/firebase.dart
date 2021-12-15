import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConfig {
  final FirebaseFirestore firestoreInstance ;
  final FirebaseAuth firebaseAuthInstance ;
  FirebaseConfig({
    required this.firestoreInstance,
    required this.firebaseAuthInstance,
  });
}
