import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseStorageRequest {
  FirebaseStorageRequest(this.firebaseStorage);

  FirebaseStorage firebaseStorage;

  Future<String> uploadFile(
    String path,
    File data, {
    Map<String, String>? metaData,
  }) async {
    try {
      final ref = firebaseStorage.ref(path);
      await ref.putFile(data, SettableMetadata(customMetadata: metaData));
      return await ref.getDownloadURL();
    } on Exception catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      return ' ';
    }
  }
}
