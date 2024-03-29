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

  Future<Either<FirestoreException, bool>> createKalaUser(
    User user,
    String authType,
  ) async {
    try {
      await firebaseConfig.firestore
          .collection(firestorePaths.user)
          .doc(user.uid)
          .set(KalaUser.fromSocialAuthUser(user, authType: authType).toMap());
      return const Right(true);
    } on Exception catch (e) {
      return Left(handleFirestoreError(e));
    }
  }
}
