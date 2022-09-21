import 'dart:developer' show log;
import 'dart:io';
import 'dart:math' hide log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart'
    show FakeFirebaseFirestore;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kala/config/register_singletons.dart';
import 'package:kala/features/artist_page/add_new_content/bloc/add_new_content_bloc.dart';
import 'package:kala/features/gallery/content/models/content.dart';

class ContentMock {
  static Content fakeContent(int id, [String? overrideArtistID]) {
    const vincent =
        'https://cdn.britannica.com/78/43678-050-F4DC8D93/Starry-Night-canvas-Vincent-van-Gogh-New-1889.jpg';
    const smallImage =
        'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Vincent_van_Gogh_-_The_Church_in_Auvers-sur-Oise%2C_View_from_the_Chevet_-_Google_Art_Project.jpg/640px-Vincent_van_Gogh_-_The_Church_in_Auvers-sur-Oise%2C_View_from_the_Chevet_-_Google_Art_Project.jpg';
    return Content(
      imageUrl: Random().nextBool() ? vincent : smallImage,
      artistName: 'Artist#$id',
      artistID: overrideArtistID ?? 'AA##$id',
      title: 'A$id',
      viewMode: ContentViewMode.grid,
      price: 100,
      docID: '$id',
      fileSize: 200,
      imgHeight: 100,
      imgWidth: 100,
      uploadTimestamp: Timestamp.now(),
      description:
          'Description Description Description Description Description',
    );
  }

  Future<void> populateFakeContentInFirestore(
    int length,
  ) async {
    final image = await DefaultCacheManager()
        .downloadFile(ContentMock.fakeContent(1).imageUrl.toString());
    for (var i = 0; i < length; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await addNewMockContent(image.file, i);
    }
    if (firebaseConfig.firestore is FakeFirebaseFirestore) {
      log((firebaseConfig.firestore as FakeFirebaseFirestore).dump());
    }
  }

  Future<void> addNewMockContent(File image, [int? index]) async {
    final addNewContentCubit = AddNewContentCubit.mock();

    final fileExists = image.existsSync();
    assert(fileExists);
    await addNewContentCubit.editNewContent(ContentProps.image, image);
    await addNewContentCubit.editNewContent(
      ContentProps.title,
      index == null ? 'test_title' : '$index',
    );
    await addNewContentCubit.editNewContent(ContentProps.price, 100);
    await addNewContentCubit.addNewContent();
  }
}
