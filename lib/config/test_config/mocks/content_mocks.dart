import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/main.dart';

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
      price: 100,
      docID: '$id',
      fileSize: 200,
      imgHeight: 100,
      imgWidth: 100,
      uploadTimestamp: Timestamp.now(),
      description:
          'Description Description Description Description Description Description Description',
    );
  }
}

Future<void> populateFakeContentInFirestore(
  FirebaseFirestore firestore,
  int length,
) async {
  for (var i = 0; i < length; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await firestore
        .collection(FirestorePaths.contentCollection)
        .add(ContentMock.fakeContent(i).toMap());
  }
}

Future<void> populateFakeUserContentInFirestore(
  FirebaseFirestore firestore,
  int length,
) async {
  final uid = firestore is FakeFirebaseFirestore
      ? FirebaseMocks.firebaseMockUser.uid
      : firebaseConfig?.auth.currentUser?.uid;

  for (var i = 0; i < length; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    await firestore
        .collection(FirestorePaths.contentCollection)
        .add(ContentMock.fakeContent(i, uid).toMap());
  }
}
