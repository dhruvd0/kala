import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/features/auth/bloc/kala_user_bloc.dart';
import 'package:kala/features/auth/repositories/social_integration/social_integration.dart';
import 'package:kala/services/firebase/firebase_error.dart';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  final socialSignIn = MockSocialSignIn();
  final userCollectionRepo = MockUserCollectionRepository();
  final uid = const Uuid().v4();

  setUp(() async {
    getIt.registerSingleton<FirebaseConfig>(
      MockFirebaseConfig(signedInUserID: uid),
    );
    registerFallbackValue(getIt.get<FirebaseConfig>().auth.currentUser);
  });

  tearDown(() {
    getIt.reset();
  });

  group('Auth: ', () {
    test('Test to authenticate with social sign and create a Kala User',
        () async {
      when(() => socialSignIn.signInWithGoogle()).thenAnswer(
        (invocation) async => Right(
          getIt.get<FirebaseConfig>().auth.currentUser!,
        ),
      );
      when(
        () => userCollectionRepo.getKalaUser(
          any(that: const TypeMatcher<String>()),
        ),
      ).thenAnswer(
        (invocation) async => Left(DocumentNotFound()),
      );
      when(
        () => userCollectionRepo.createKalaUser(
          any(that: const TypeMatcher<User>()),
          any(that: const TypeMatcher<String>()),
        ),
      ).thenAnswer(
        (invocation) async => Right(Timestamp.now()),
      );
      final kalaUserBloc = KalaUserBloc(
        socialSignIn: socialSignIn,
        userCollectionRepository: userCollectionRepo,
      );

      await kalaUserBloc.authenticateWithSocialAuth(AuthTypes.google);

      expect(kalaUserBloc.state.runtimeType, FetchedKalaUserState);
      expect(
        (kalaUserBloc.state as FetchedKalaUserState).kalaUser.uid,
        uid,
      );
    });
  });
}
