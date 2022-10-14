import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kala/common/models/kala_user.dart';
import 'package:kala/common/services/firebase/error_handler.dart';
import 'package:kala/common/services/firebase/firebase_error.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/features/auth/services/user_profile_service.dart';

class UserProfileRepository {
  UserProfileRepository(this.userProfileService);

  final UserProfileService userProfileService;
  Future<Either<FirestoreException, KalaUser>> getKalaUser(String uid) async {
    final result = await userProfileService.getKalaUser(uid);

    return result.fold(
      (l) {
        return Left(l);
      },
      (json) => Right(KalaUser.fromMap(json)),
    );
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
