import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:kala/config/firebase/firebase.dart';

class FirebaseMocks {
  static final FakeFirebaseFirestore mockFirestore = FakeFirebaseFirestore();
  static final MockGoogleSignIn googleAuthMock = MockGoogleSignIn();
  static final firebaseMockUser = MockUser(
    isAnonymous: true,
    uid: 'test_id',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
    photoURL: "photo",
  );
  static Future<MockFirebaseAuth> getMockAuthFromGoogleAuthMock(
      [bool? signedIn]) async {
    try {
      final auth = MockFirebaseAuth(
        mockUser: (signedIn ?? false) ? firebaseMockUser : null,
        signedIn: signedIn ?? false,
      );
      return auth;
    } on AssertionError {
      var mockFirebaseAuth = MockFirebaseAuth(mockUser: firebaseMockUser);
      if (signedIn ?? false) {
        mockFirebaseAuth.signInAnonymously();
      }
      return mockFirebaseAuth;
    }
  }

  static Future<FirebaseConfig> getMockFirebaseConfig({bool? signedIn}) async {

    FirebaseConfig mockFirebaseConfig = FirebaseConfig(
      firestore: FirebaseMocks.mockFirestore,
      auth: await FirebaseMocks.getMockAuthFromGoogleAuthMock(signedIn),
    );
    if (signedIn ?? false) {
      assert(mockFirebaseConfig.auth.currentUser != null);
    }
    return mockFirebaseConfig;
  }
}
