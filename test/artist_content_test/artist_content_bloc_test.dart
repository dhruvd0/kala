import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kala/common/models/art.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/features/artist_content/cubit/artist_content_cubit.dart';
import 'package:kala/features/artist_content/repositories/artist_content_repo.dart';
import 'package:kala/features/artist_content/services/artist_content_service.dart';
import 'package:uuid/uuid.dart';

import '../firestore_mock_service.dart';
import '../model_mocks.dart';
import '../services_mocks.dart';

void main() {
  final uid = const Uuid().v4();

  setUp(() async {
    setupBasicMockServices();

    await firebaseConfig.firestore.mockGalleryCollectionOfAnArtist(uid);
  });

  tearDown(() {
    getIt.reset();
  });
  group('Artist Content: ', () {
    blocTest<ArtistContentCubit, ArtistContentState>(
      'Test to fetch initial art of an artist',
      build: () {
        return ArtistContentCubit(
          ArtistContentRepository(ArtistContentService(uid)),
        );
      },
      act: (bloc) async => bloc.getArtistArt(uid),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const ArtistContentLoadingState(),
        const TypeMatcher<ArtistContentLoadedState>()
      ],
      verify: (bloc) {
        final state = bloc.state as ArtistContentLoadedState;
        expect(state.userArt, isNotEmpty);
        expect(state.userArt.length, 10);
        verifyUserArtHasCorrectArtistID(uid, state.userArt);
      },
    );
    blocTest<ArtistContentCubit, ArtistContentState>(
      'Test to paginate  art of an artist',
      build: () => ArtistContentCubit(
        ArtistContentRepository(ArtistContentService(uid)),
      ),
      act: (bloc) async {
        await bloc.getArtistArt(uid);
        await bloc.getArtistArt(uid, 1);
      },
      expect: () => [
        const ArtistContentLoadingState(),
        const TypeMatcher<ArtistContentLoadedState>(),
        const TypeMatcher<ArtistContentLoadedState>()
      ],
      verify: (bloc) {
        final state = bloc.state as ArtistContentLoadedState;
        expect(state.userArt, isNotEmpty);
        expect(state.userArt.length, 20);
        verifyUserArtHasCorrectArtistID(
          uid,
          state.userArt,
        );
      },
    );

    final list = List.generate(20, (index) => fakeArtJson(index, uid))
        .map((e) => Art.fromMap(e))
        .toList();
    blocTest<ArtistContentCubit, ArtistContentState>(
      'Test to fetch new  art after pagination of an artist',
      build: () => ArtistContentCubit(
        ArtistContentRepository(ArtistContentService(uid)),
      ),
      act: (bloc) async {
        await bloc.getArtistArt(uid);
      },
      seed: () {
        return ArtistContentLoadedState(
          userArt: list,
          acquiredArt: const [],
        );
      },
      expect: () => [
        const TypeMatcher<ArtistContentLoadedState>(),
      ],
      verify: (bloc) async {
        final state = bloc.state as ArtistContentLoadedState;

        expect(state.userArt.length, 30);
        expect(state.userArt.first.docID != list.first.docID, true);
        verifyUserArtHasCorrectArtistID(
          uid,
          state.userArt,
        );
      },
    );




  
  });
}

void verifyUserArtHasCorrectArtistID(String artistID, List<Art> userArt) {
  expect(userArt.any((element) => element.artistID != artistID), false);
}
