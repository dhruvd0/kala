import 'dart:html';

import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/main.dart';

Future<bool> addNewUser(KalaUser kalaUser) async {
  try {
    await firebaseConfig.firestoreInstance
        .collection("users")
        .doc(kalaUser.name)
        .set(kalaUser.toMap());
    return true;
  } catch (e) {
    return false;
  }
}
