import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/config/firebase/firestore_paths.dart';

class FirebaseMocks {
  static final FakeFirebaseFirestore mockFirestore = FakeFirebaseFirestore();
  static final MockGoogleSignIn googleAuthMock = MockGoogleSignIn();
  static final firebaseMockUser = MockUser(
    isAnonymous: false,
    uid: 'test_id',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
    photoURL: "photo",
  );
  static Future<MockFirebaseAuth> getMockAuthFromGoogleAuthMock(
      [bool? signedIn]) async {
    final googleSignIn = FirebaseMocks.googleAuthMock;
    final signinAccount = await googleSignIn.signIn();

    final auth = MockFirebaseAuth(
      mockUser: firebaseMockUser,
      signedIn: signedIn ?? false,
    );
    return auth;
  }

  static Future<FirebaseConfig> getMockFirebaseConfig({bool? signedIn}) async {
    await FirebaseMocks.mockFirestore
        .collection(FirestorePaths.userCollection)
        .add({"test": "test"});

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