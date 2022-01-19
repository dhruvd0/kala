import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/gallery/content/models/content.dart';

class ContentMock {
  static Content fakeContent(int id) {
    var vincent =
        'https://cdn.britannica.com/78/43678-050-F4DC8D93/Starry-Night-canvas-Vincent-van-Gogh-New-1889.jpg';
    var smol =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Vincent_van_Gogh_-_The_Church_in_Auvers-sur-Oise%2C_View_from_the_Chevet_-_Google_Art_Project.jpg/640px-Vincent_van_Gogh_-_The_Church_in_Auvers-sur-Oise%2C_View_from_the_Chevet_-_Google_Art_Project.jpg";
    return Content(
      imageUrl: Random().nextBool() ? vincent : smol,
      artistName: "Artist#$id",
      artistID: "AA##$id",
      title: "A$id",
      docID: "$id",
      fileSize: 200,
      imgHeight: 100,
      imgWidth: 100,
      uploadTimestamp: Timestamp.now(),
      description: "ejjfwjkefjkwjnefjwjkefj fnewjonjfkwejknjfk ewfwmeofmkwm",
    );
  }
}

Future<void> populateFakeContentInFirestore(
  FirebaseFirestore firestore,
  int length,
) async {
  for (int i = 0; i < length; i++) {
    await Future.delayed(const Duration(milliseconds: 500));
    await firestore
        .collection(FirestorePaths.fakeContentCollection)
        .add(ContentMock.fakeContent(i).toMap());
  }
}
