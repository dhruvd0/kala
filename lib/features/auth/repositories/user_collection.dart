import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/features/auth/models/kala_user.dart';
import 'package:kala/services/firebase/error_handler.dart';
import 'package:kala/services/firebase/firebase_error.dart';

class UserCollectionRepository {
  Future<Either<FirestoreException, KalaUser>> getKalaUser(String uid) async {
    try {
      final doc = await firebaseConfig.firestore
          .collection(firestorePaths.user)
          .doc(uid)
          .get();
      if (doc.data() == null) {
        throw DocumentNotFound();
      }
      return Right(KalaUser.fromMap(doc.data()!));
    } on Exception catch (e) {
      return Left(handleFirestoreError(e));
    }
  }

  Future<Either<FirestoreException, Timestamp>> createKalaUser(
    User user,
    String authType,
  ) async {
    try {
      await firebaseConfig.firestore
          .collection(firestorePaths.user)
          .doc(user.uid)
          .set(KalaUser.fromSocialAuthUser(user, authType: authType).toMap());
      return Right(Timestamp.now());
    } on Exception catch (e) {
      return Left(handleFirestoreError(e));
    }
  }
}
