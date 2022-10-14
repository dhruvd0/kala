import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:kala/common/services/firebase/firebase_error.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/features/auth/bloc/kala_user_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../firebase_config_mock.dart';
import '../repo_mocks.dart';

void main() {
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
    blocTest<AuthenticatedProfileBloc, KalaUserState>(
      'Test to register kala user.',
      build: () {
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
        return AuthenticatedProfileBloc(userCollectionRepo);
      },
      act: (bloc) async => bloc.syncUserProfile(),
      expect: () => [
        KalaUserLoadingState(),
        UserNotFoundState(),
        KalaUserLoadingState(),
        const TypeMatcher<FetchedKalaUserState>()
      ],
    );

    blocTest<AuthenticatedProfileBloc, KalaUserState>(
      'Test to fetch a user profile.',
      build: () {
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
        return AuthenticatedProfileBloc(userCollectionRepo);
      },
      act: (bloc) async => bloc.syncUserProfile(),
      expect: () => [
        KalaUserLoadingState(),
        UserNotFoundState(),
        KalaUserLoadingState(),
        const TypeMatcher<FetchedKalaUserState>()
      ],
    );

   
  });
}
