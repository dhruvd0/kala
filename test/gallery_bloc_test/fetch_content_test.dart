import 'package:flutter_test/flutter_test.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/features/auth/bloc/kala_user_bloc.dart';
import 'package:kala/features/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

int length = 10;
void main() {
  test('Test to get initial content for gallery', () async {
    final galleryBloc = await galleryBlocSetup();
    await galleryBloc.getContentList(
      1,
      collectionSegment: CollectionSegment.initial,
    );
    expect(galleryBloc.state.contentSlideList.isNotEmpty, true);
    expect(galleryBloc.state.contentSlideList.first.title, '${length - 1}');
    expect(galleryBloc.state.contentSlideList.length, 10);
    expect(galleryBloc.state.contentSlideList.last.title, '${length - 10}');
  });
  test('Test to paginate content list for gallery', () async {
    length = 50;
    final galleryBloc = await galleryBlocSetup();
    await galleryBloc.getContentList(
      1,
      collectionSegment: CollectionSegment.initial,
    );
    await galleryBloc.getContentList(
      2,
      collectionSegment: CollectionSegment.next,
    );
    expect(galleryBloc.state.contentSlideList.length, 20);
    expect(galleryBloc.state.contentSlideList.last.title, '30');
    await galleryBloc.getContentList(
      3,
      collectionSegment: CollectionSegment.next,
    );
    await galleryBloc.getContentList(
      4,
      collectionSegment: CollectionSegment.next,
    );
    expect(galleryBloc.state.contentSlideList.length, 40);
    expect(galleryBloc.state.contentSlideList.last.title, '10');
  });
}

Future<GalleryBloc> galleryBlocSetup() async {
  await ContentMock().populateFakeContentInFirestore(
    length,
  );

  final galleryBloc = GalleryBloc(
    kalaUserBloc: KalaUserBloc(),
  );
  return galleryBloc;
}
