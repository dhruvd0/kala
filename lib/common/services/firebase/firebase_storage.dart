import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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

      return ref.getDownloadURL();
    } on Exception catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      await Fluttertoast.showToast(msg: e.toString());
      return '';
    }
  }
}
