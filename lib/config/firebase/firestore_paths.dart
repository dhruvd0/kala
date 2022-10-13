import 'package:kala/config/dependencies.dart';
import 'package:kala/config/environment.dart';

const String _artCollection = 'art';
const String _userCollection = 'users';
FirestoreCollectionPaths get firestorePaths =>
    getIt.get<FirestoreCollectionPaths>();

class FirestoreCollectionPaths {
  FirestoreCollectionPaths();

  String get art => _artCollection + Env.getEnvironmentTag();

  String get user => _userCollection + Env.getEnvironmentTag();
}
