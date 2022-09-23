import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/typedefs.dart';
import 'package:kala/features/auth/models/kala_user.dart';
import 'package:kala/services/firebase/firebase_error.dart';

class UserCollectionRepository {
  Future<Either<FirestoreError, KalaUser>> getKalaUser(String uid) async {
    try {
      final doc = await firebaseConfig.firestore
          .collection(firestorePaths.user)
          .doc(uid)
          .get();
      return right(KalaUser.fromMap(doc.data()!));
    } on Exception catch (e) {
      return left(FirestoreError(message: e.toString()));
    }
  }

  Future<Either<FirestoreError, Timestamp>> createKalaUser(
    String uid,
    Json data,
  ) async {
    try {
      await firebaseConfig.firestore
          .collection(firestorePaths.user)
          .doc(uid)
          .set(data);
      return right(Timestamp.now());
    } on Exception catch (e) {
      return left(FirestoreError(message: e.toString()));
    }
  }
}
