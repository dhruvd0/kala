import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kala/common/models/kala_user.dart';
import 'package:kala/common/services/firebase/error_handler.dart';
import 'package:kala/common/services/firebase/firebase_error.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/typedefs.dart';

class UserProfileService {
  Future<Either<FirestoreException, Json>> getKalaUser(String uid) async {
    try {
      final doc = await firebaseConfig.firestore
          .collection(firestorePaths.user)
          .doc(uid)
          .get();
      if (doc.data() == null) {
        throw DocumentNotFound();
      }
      return Right(doc.data()!);
    } on Exception catch (e) {
      return Left(handleFirestoreError(e));
    }
  }
}
