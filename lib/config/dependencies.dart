import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/features/auth/bloc/kala_user_bloc.dart';
import 'package:kala/features/auth/repositories/social_integration/social_integration.dart';
import 'package:kala/features/auth/repositories/user_collection.dart';
import 'package:kala/features/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/features/gallery/repositories/gallery_repository.dart';
import 'package:kala/features/gallery/services/gallery_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

final getIt = GetIt.instance;
FirebaseConfig get firebaseConfig => getIt.get<FirebaseConfig>();
Future<void> registerDependencies() async {
  (await _clientsAndServices()).map((e) => getIt.registerSingleton(e));
  (_repositories()).map((e) => getIt.registerSingleton(e));
  (_blocs()).map((e) => getIt.registerSingleton(e));
}

Future<List<Object>> _clientsAndServices() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return [
    packageInfo,
    await _setupFirebase(),
    FirestoreCollectionPaths(),
    GalleryService()
  ];
}

List<Object> _repositories() {
  return [
    SocialSignIn(),
    UserCollectionRepository(),
    GalleryRepository(getIt.get())
  ];
}

List<Object> _blocs() {
  return [
    KalaUserBloc(
      socialSignIn: getIt.get(),
      userCollectionRepository: getIt.get(),
    ),
    GalleryBloc(getIt.get())
  ];
}

Future<FirebaseConfig> _setupFirebase() async {
  return FirebaseConfig(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    remoteConfig: FirebaseRemoteConfig.instance,
    storage: FirebaseStorage.instance,
  );
}
