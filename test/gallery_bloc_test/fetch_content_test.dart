import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';

void main() {
  test("Test to get and paginate content for gallery", () async {
    var length = 20;
    await populateFakeContentInFirestore(
      FirebaseMocks.mockFirestore,
      length,
    );
    log(FirebaseMocks.mockFirestore.dump());
    GalleryBloc galleryBloc = GalleryBloc(
      kalaUserBloc: KalaUserBloc(),
      firebaseFirestore: FirebaseMocks.mockFirestore,
    );
    await galleryBloc.getContentList();
    expect(galleryBloc.state.contentSlideList.first.docID, "0");
    expect(galleryBloc.state.contentSlideList.length, 5);
    expect(galleryBloc.state.contentSlideList.last.docID, "4");

    await galleryBloc.getContentList();
    expect(galleryBloc.state.contentSlideList.length, 10);
    expect(galleryBloc.state.contentSlideList.last.docID, "9");
  });
}

