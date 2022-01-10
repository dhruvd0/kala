import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';

import '../mocks/content_mocks.dart';

void main() {
  test("Test to get content for gallery", () async {
    var length = 30;
    await populateFakeContentInFirestore(length);
    log(FirebaseMocks.mockFirestore.dump());
    GalleryBloc galleryBloc = GalleryBloc(
      kalaUserBloc: KalaUserBloc(),
      firebaseFirestore: FirebaseMocks.mockFirestore,
    );
    await galleryBloc.getContentList();
    List<Content> contentList = galleryBloc.state.contentSlideList;
    expect(contentList.length, length);
    expect(contentList[0].docID, "0");
  });
}

Future<void> populateFakeContentInFirestore(int length) async {
  for (int i = 0; i < length; i++) {
    await FirebaseMocks.mockFirestore
        .collection(FirestorePaths.contentCollection)
        .add(ContentMock.fakeContent(i).toMap());
  }
  log(FirebaseMocks.mockFirestore.dump());
}
