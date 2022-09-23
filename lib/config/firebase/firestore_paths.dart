import 'package:kala/config/dependencies.dart';
import 'package:kala/config/environment.dart';

const String _artCollection = 'art';
const String _userCollection = 'users';
FirestoreCollectionPaths get firestorePaths =>
    getIt.get<FirestoreCollectionPaths>();

class FirestoreCollectionPaths {
  FirestoreCollectionPaths();

  final String _art = _artCollection;
  final String _user = _userCollection;

  String get art => _art + Env.getEnvironmentTag();

  String get user => _user + Env.getEnvironmentTag();
}
