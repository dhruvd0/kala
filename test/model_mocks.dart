import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kala/features/gallery/art/models/art.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

Art fakeArt(int id, [String? overrideArtistID]) {
  const vincent =
      'https://cdn.britannica.com/78/43678-050-F4DC8D93/Starry-Night-canvas-Vincent-van-Gogh-New-1889.jpg';
  const smallImage =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Vincent_van_Gogh_-_The_Church_in_Auvers-sur-Oise%2C_View_from_the_Chevet_-_Google_Art_Project.jpg/640px-Vincent_van_Gogh_-_The_Church_in_Auvers-sur-Oise%2C_View_from_the_Chevet_-_Google_Art_Project.jpg';
  return Art(
    imageUrl: Random().nextBool() ? vincent : smallImage,
    artistName: 'Artist#$id',
    artistID: overrideArtistID ?? 'AA##$id',
    title: 'A$id',
    viewMode: ArtViewMode.grid,
    price: 100,
    docID: '$id',
    fileSize: 200,
    imgHeight: 100,
    imgWidth: 100,
    uploadTimestamp: Timestamp.now(),
    description: 'Description Description Description Des'
        ' Description',
  );
}
