import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:fake_firebase_remote_config/fake_firebase_remote_config.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firebase.dart';

MockFirebaseConfig get mockFirebaseConfig => getIt.get<MockFirebaseConfig>();

class MockFirebaseConfig extends FirebaseConfig {
  MockFirebaseConfig({String? signedInUserID})
      : super(
          auth: MockFirebaseAuth(
            signedIn: signedInUserID != null,
            mockUser:
                signedInUserID != null ? MockUser(uid: signedInUserID) : null,
          ),
          firestore: FakeFirebaseFirestore(),
          remoteConfig: FakeRemoteConfig(),
          storage: MockFirebaseStorage(),
        );
}
