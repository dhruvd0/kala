import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/features/artist_profile/services/user_profile_service.dart';
import 'package:kala/features/auth/repositories/social_integration/social_integration.dart';
import 'package:kala/features/gallery/services/gallery_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'firebase_config_mock.dart';

class MockSocialSignIn extends Mock implements SocialSignIn {}

class MockGalleryService extends Mock implements GalleryService {}

class MockPackageInfo extends Mock implements PackageInfo {}

class MockUserProfileService extends Mock implements UserProfileService {}

void setupBasicMockServices([String? firebaseAuthUid]) {
  final packageInfo = MockPackageInfo();
  when(() => packageInfo.version).thenReturn('test_dev');
  getIt
    ..registerSingleton<PackageInfo>(packageInfo)
    ..registerSingleton<FirebaseConfig>(
      MockFirebaseConfig(signedInUserID: firebaseAuthUid),
    )
    ..registerSingleton(FirestoreCollectionPaths());
}
