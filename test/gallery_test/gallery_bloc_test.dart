import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/features/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/features/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/features/gallery/repositories/gallery_repository.dart';
import 'package:kala/features/gallery/services/gallery_service.dart';

import '../firestore_mock_service.dart';
import '../model_mocks.dart';
import '../services_mocks.dart';

void main() {
  setUp(() async {
    setupBasicMockServices();
    await firebaseConfig.firestore.mockGalleryCollection();
  });

  tearDown(() {
    getIt.reset();
  });
  group('Gallery: ', () {
    blocTest<GalleryBloc, GalleryState>(
      'Test to fetch initial gallery art',
      build: () => GalleryBloc(GalleryRepository(GalleryService())),
      act: (bloc) async => bloc.getArtList(),
      wait: const Duration(milliseconds: 100),
      expect: () =>
          [LoadingGalleryState(), const TypeMatcher<FetchedGalleryState>()],
      verify: (bloc) {
        final state = bloc.state as FetchedGalleryState;
        expect(state.artSlideList, isNotEmpty);
        expect(state.artSlideList.length, 10);
      },
    );
    blocTest<GalleryBloc, GalleryState>(
      'Test to paginate gallery art',
      build: () => GalleryBloc(GalleryRepository(GalleryService())),
      act: (bloc) async {
        await bloc.getArtList();
        await bloc.getArtList(1);
      },
      expect: () => [
        LoadingGalleryState(),
        const TypeMatcher<FetchedGalleryState>(),
        const TypeMatcher<FetchedGalleryState>()
      ],
      verify: (bloc) {
        final state = bloc.state as FetchedGalleryState;
        expect(state.artSlideList, isNotEmpty);
        expect(state.artSlideList.length, 20);
      },
    );

    final list = List.generate(20, (index) => fakeArt(index));
    blocTest<GalleryBloc, GalleryState>(
      'Test to fetch new gallery art after pagination',
      build: () => GalleryBloc(GalleryRepository(GalleryService())),
      act: (bloc) async {
        await bloc.getArtList();
      },
      seed: () {
        return FetchedGalleryState(
          artSlideList: list,
        );
      },
      expect: () => [
        const TypeMatcher<FetchedGalleryState>(),
      ],
      verify: (bloc) async {
        final state = bloc.state as FetchedGalleryState;

        expect(state.artSlideList.length, 30);
        expect(state.artSlideList.first.docID != list.first.docID, true);
      },
    );
  });
}
