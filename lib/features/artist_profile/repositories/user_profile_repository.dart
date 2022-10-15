import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kala/common/models/kala_user.dart';
import 'package:kala/common/services/firebase/firebase_error.dart';
import 'package:kala/features/artist_profile/services/user_profile_service.dart';

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

  Future<Either<FirestoreException, bool>> createKalaUser(
    User user,
    String authType,
  ) async {
    return userProfileService.createKalaUser(user, authType);
  }
}
