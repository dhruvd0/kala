import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kala/config/typedefs.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/firebase/crashlytics.dart';

class FirestoreQueries {
  static Future<List<Json>> getAllCollectionDocuments(String collection,
      {String? orderByField}) async {
    try {
      QuerySnapshot<Json>? querySnapshot = await firebaseConfig?.firestore
          .collection(collection)
          .orderBy(orderByField ?? FieldPath.documentId)
          .get();
      if (querySnapshot == null || querySnapshot.docs.isEmpty) {
        setCrashlyticsCustomKey("collection", collection);
        setCrashlyticsCustomKey("orderByField", orderByField);
      }
      if (querySnapshot == null) {
        throw Exception("Null Query Snapshot");
      }
      if (querySnapshot.docs.isEmpty) {
        throw Exception("Empty Query Docs");
      }
      List<Json> jsonList = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        data.putIfAbsent("docID", () => doc.id);
        jsonList.add(data);
      }
      return jsonList;
    } on PlatformException {
      Fluttertoast.showToast(msg: "No Internet");
      return [];
    }
  }
}
