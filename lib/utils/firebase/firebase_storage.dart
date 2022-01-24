import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseStorageRequest {
  FirebaseStorageRequest([FirebaseStorage? firebaseStorage]) {
    this.firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;
  }

  FirebaseStorage? firebaseStorage;

  Future<String> uploadFile(
    String path,
    File data, {
    Map<String, String>? metaData,
  }) async {
    try {
      final ref = firebaseStorage?.ref(path);

      await ref!.putFile(data, SettableMetadata(customMetadata: metaData));
      if (firebaseStorage is MockFirebaseStorage) {
        final mock = firebaseStorage! as MockFirebaseStorage;
        log(mock.storedFilesMap.toString());
        return 'test_url';
      }
      return ref.getDownloadURL();
    } on Exception catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      return ' ';
    }
  }
}
