import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kala/config/typedefs.dart';
import 'package:kala/features/auth/repositories/social_integration/social_integration.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

Json fakeArtJson(int id, [String? artistID]) {
  return {
    'artistID': artistID ?? 'AA##$id',
    'artistName': 'Artist#$id',
    'description': 'Description Description Description Des'
        ' Description',
    'docID': '$id',
    'fileSize': 200,
    'imageUrl':
        'https://cdn.britannica.com/78/43678-050-F4DC8D93/Starry-Night-canvas-Vincent-van-Gogh-New-1889.jpg',
    'imgHeight': 100,
    'imgWidth': 100,
    'price': 100,
    'title': 'A$id',
    'uploadTimestamp': Timestamp.now(),
  };
}

Json fakeArtistJson(String uid) {
  return {
    'authType': AuthTypes.google.name,
    'contactURL': '',
    'lastSignIn': Timestamp.now().toDate().toIso8601String(),
    'name': 'test_name',
    'photoURL':
        'https://cdn.britannica.com/78/43678-050-F4DC8D93/Starry-Night-canvas-Vincent-van-Gogh-New-1889.jpg',
    'uid': uid,
    'bio': 'bio',
  };
}
