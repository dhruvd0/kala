
import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/main.dart';

Future<bool> addNewUser(KalaUser kalaUser) async {
  try {
    await firebaseConfig?.firestore
        .collection(FirestorePaths.userCollection)
        .doc(kalaUser.name)
        .set(kalaUser.toMap());
    return true;
  } catch (e) {
    return false;
  }
}
