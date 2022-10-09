import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:kala/config/firebase/firestore_paths.dart';

extension FirestoreMockExtensions on FakeFirebaseFirestore {
  Future<void> mockGalleryCollection() async {
    await collection(firestorePaths.art).add({});
  }
}
