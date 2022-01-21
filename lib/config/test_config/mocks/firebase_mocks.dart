import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:kala/config/firebase/firebase.dart';

class FirebaseMocks {
  static final firebaseMockUser = MockUser(
    isAnonymous: true,
    uid: 'test_id',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
    photoURL: 'photo',


  );

  static final MockFirebaseStorage mockFirebaseStorage=MockFirebaseStorage();

  static final MockGoogleSignIn googleAuthMock = MockGoogleSignIn();
  static final FakeFirebaseFirestore mockFirestore = FakeFirebaseFirestore();

  static Future<MockFirebaseAuth> getMockAuthFromGoogleAuthMock({
    bool? signedIn,
  }) async {
    try {
      final auth = MockFirebaseAuth(
        mockUser: (signedIn ?? false) ? firebaseMockUser : null,
        signedIn: signedIn ?? false,
      );
      return auth;
      // ignore: avoid_catching_errors
    } on AssertionError {
      final mockFirebaseAuth = MockFirebaseAuth(mockUser: firebaseMockUser);
      if (signedIn ?? false) {
        await mockFirebaseAuth.signInAnonymously();
        assert(mockFirebaseAuth.currentUser?.uid == firebaseMockUser.uid);
      }
      return mockFirebaseAuth;
    }
  }

  static Future<FirebaseConfig> getMockFirebaseConfig({bool? signedIn}) async {
    final mockFirebaseConfig = FirebaseConfig(
      firestore: FirebaseMocks.mockFirestore,
      auth:
          await FirebaseMocks.getMockAuthFromGoogleAuthMock(signedIn: signedIn),
    );
    if (signedIn ?? false) {
      assert(mockFirebaseConfig.auth.currentUser != null);
    }
    return mockFirebaseConfig;
  }
}
