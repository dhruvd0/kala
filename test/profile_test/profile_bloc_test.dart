import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kala/common/services/firebase/firebase_error.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/features/artist_profile/cubit/artist_profile/kala_user_bloc.dart';
import 'package:kala/features/artist_profile/repositories/user_profile_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../firebase_config_mock.dart';
import '../model_mocks.dart';
import '../services_mocks.dart';

void main() {
  final mockService = MockUserProfileService();

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
          () => mockService.getKalaUser(
            any(that: const TypeMatcher<String>()),
          ),
        ).thenAnswer(
          (invocation) async => Left(DocumentNotFound()),
        );
        when(
          () => mockService.createKalaUser(
            any(that: const TypeMatcher<User>()),
            any(that: const TypeMatcher<String>()),
          ),
        ).thenAnswer(
          (invocation) async => const Right(true),
        );
        return AuthenticatedProfileBloc(UserProfileRepository(mockService));
      },
      act: (bloc) async => bloc.syncUserProfile(),
      expect: () => [
        KalaUserLoadingState(),
        UserNotFoundState(),
        RegisteringState(),
        const TypeMatcher<FetchedKalaUserState>()
      ],
    );

    blocTest<AuthenticatedProfileBloc, KalaUserState>(
      'Test to fetch a user profile.',
      build: () {
        when(
          () => mockService.getKalaUser(
            any(that: const TypeMatcher<String>()),
          ),
        ).thenAnswer(
          (invocation) async => Right(fakeArtistJson(uid)),
        );

        return AuthenticatedProfileBloc(UserProfileRepository(mockService));
      },
      act: (bloc) async => bloc.syncUserProfile(),
      expect: () =>
          [KalaUserLoadingState(), const TypeMatcher<FetchedKalaUserState>()],
    );
  });
}
