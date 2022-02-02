import 'package:flutter_test/flutter_test.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

void main() {
  tearDown(() {
    firebaseConfig = null;
  });
  test(
    'Test to add new content to Kala gallery as the first content',
    () async {
      await ContentMock().addNewMockContent();

      final kalaUserContentCubit = KalaUserContentBloc.mock()
        ..toggleEditMode(forceToggle: false);

      await kalaUserContentCubit.getUserContent(
        2,
        collectionSegment: CollectionSegment.initial,
      );

      expect(kalaUserContentCubit.state.userContent?.length, 1);
      expect(kalaUserContentCubit.state.userContent!.first.isValid(), true);
    },
  );
  testAddNewContent();
}

void testAddNewContent() {
  test(
    'Test to add new content to Kala gallery',
    () async {
      assert(firebaseConfig == null);
      final kalaUserContentCubit = KalaUserContentBloc.mock()
        ..toggleEditMode(forceToggle: false);
      final galleryBloc = GalleryBloc(
        kalaUserBloc: KalaUserBloc.mock(),
      );
      final contentMock = ContentMock();
      await contentMock.populateFakeContentInFirestore(2);
      await galleryBloc.getContentList(
        2,
        collectionSegment: CollectionSegment.initial,
      );
      expect(galleryBloc.state.contentSlideList.length, 2);
      await kalaUserContentCubit.getUserContent(
        1,
        collectionSegment: CollectionSegment.initial,
      );
      await contentMock.addNewMockContent(100);

      kalaUserContentCubit.toggleEditMode(forceToggle: false);
      await kalaUserContentCubit.getUserContent(
        2,
        collectionSegment: CollectionSegment.previous,
      );
      await galleryBloc.getContentList(
        2,
        collectionSegment: CollectionSegment.previous,
      );

      expect(kalaUserContentCubit.state.userContent?.length, 3);
      expect(kalaUserContentCubit.state.userContent!.first.isValid(), true);
      expect(kalaUserContentCubit.state.userContent!.first.title, '100');
      expect(galleryBloc.state.contentSlideList.length, 3);
      expect(galleryBloc.state.contentSlideList.first.title, '100');
    },
  );
}
