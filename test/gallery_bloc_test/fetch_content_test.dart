import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/utils/helper_bloc/content_pagination/content_pagination_bloc.dart';

var length = 50;
void main() {
  test("Test to get initial content for gallery", () async {
    GalleryBloc galleryBloc = await galleryBlocSetup();
    await galleryBloc.getContentList();
    expect(galleryBloc.state.contentSlideList.isNotEmpty, true);
    expect(galleryBloc.state.contentSlideList.first.docID, "${length - 1}");
    expect(galleryBloc.state.contentSlideList.length, 10);
    expect(galleryBloc.state.contentSlideList.last.docID, "${length - 10}");
  });
  test("Test to paginate content list for gallery", () async {
    GalleryBloc galleryBloc = await galleryBlocSetup();
    await galleryBloc.getContentList();
    await galleryBloc.getContentList();
    expect(galleryBloc.state.contentSlideList.length, 20);
    expect(galleryBloc.state.contentSlideList.last.docID, "30");
    await galleryBloc.getContentList();
    await galleryBloc.getContentList();
    expect(galleryBloc.state.contentSlideList.length, 40);
    expect(galleryBloc.state.contentSlideList.last.docID, "10");
  });
}

Future<GalleryBloc> galleryBlocSetup() async {
  await populateFakeContentInFirestore(
    FirebaseMocks.mockFirestore,
    length,
  );

  GalleryBloc galleryBloc = GalleryBloc(
      kalaUserBloc: KalaUserBloc(),
      contentPaginationCubit: ContentPaginationCubit(
        collection: FirestorePaths.fakeContentCollection,
        orderIsDescending: true,
        orderByField: "uploadTimestamp",
        firebaseFirestore: FirebaseMocks.mockFirestore,
      ));
  return galleryBloc;
}
