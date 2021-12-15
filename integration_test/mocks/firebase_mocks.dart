import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class FirebaseMocks {
  static final FakeFirebaseFirestore mockFirestore = FakeFirebaseFirestore()
    ;
  static final MockGoogleSignIn googleAuthMock = MockGoogleSignIn();
  static final firebaseMockUser = MockUser(
      isAnonymous: true,
      uid: 'test_id',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
      photoURL: "photo");
  static Future<MockFirebaseAuth> getMockAuthFromGoogleAuthMock() async {
    final googleSignIn = FirebaseMocks.googleAuthMock;
    final signinAccount = await googleSignIn.signIn();
   
 

    final auth = MockFirebaseAuth(mockUser: firebaseMockUser);
    return auth;
  }
}
