import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:kala/config/firebase/firestore_paths.dart';

import 'model_mocks.dart';

extension FirestoreMockExtensions on FirebaseFirestore {
  Future<void> mockGalleryCollection([int galleryTotalLength = 50]) async {
    assert(this is FakeFirebaseFirestore, 'Attempted to mock real firestore');
    for (var i = 1; i < galleryTotalLength; i++) {
      await collection(firestorePaths.art).add(fakeArtJson(i));
    }
  }

  Future<void> mockGalleryCollectionOfAnArtist(
    String artistID, [
    int galleryTotalLength = 50,
  ]) async {
    assert(this is FakeFirebaseFirestore, 'Attempted to mock real firestore');
    for (var i = 1; i < galleryTotalLength; i++) {
      await collection(firestorePaths.art).add(fakeArtJson(i, artistID));
    }
  }
}
