import 'package:flutter_test/flutter_test.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';

int length = 10;
void main() {
  test('Test to get initial content for gallery', () async {
    final galleryBloc = await galleryBlocSetup();
    await galleryBloc.getContentList(1);
    expect(galleryBloc.state.contentSlideList.isNotEmpty, true);
    expect(galleryBloc.state.contentSlideList.first.docID, '${length - 1}');
    expect(galleryBloc.state.contentSlideList.length, 10);
    expect(galleryBloc.state.contentSlideList.last.docID, '${length - 10}');
  });
  test('Test to paginate content list for gallery', () async {
    length = 50;
    final galleryBloc = await galleryBlocSetup();
    await galleryBloc.getContentList(1);
    await galleryBloc.getContentList(2);
    expect(galleryBloc.state.contentSlideList.length, 20);
    expect(galleryBloc.state.contentSlideList.last.docID, '30');
    await galleryBloc.getContentList(3);
    await galleryBloc.getContentList(4);
    expect(galleryBloc.state.contentSlideList.length, 40);
    expect(galleryBloc.state.contentSlideList.last.docID, '10');
  });
}

Future<GalleryBloc> galleryBlocSetup() async {
  await populateFakeContentInFirestore(
    FirebaseMocks.mockFirestore,
    length,
  );

  final galleryBloc = GalleryBloc(
    kalaUserBloc: KalaUserBloc(),
   
  );
  return galleryBloc;
}
