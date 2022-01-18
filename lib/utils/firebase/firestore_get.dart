import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kala/config/typedefs.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/firebase/crashlytics.dart';
import 'package:kala/utils/firebase/page_data.dart';

class FirestoreQueries {
  FirebaseFirestore? firestore;
  FirestoreQueries({this.firestore}) {
    firestore = firestore ?? firebaseConfig!.firestore;
  }
  Future<FirestorePageResponse?> paginateCollectionDocuments(
      FirestorePageRequest request) async {
    try {
      QuerySnapshot<Json>? querySnapshot;
      var orderByQuery = firestore?.collection(request.collection).orderBy(
            request.orderByField,
            descending: request.orderIsDescending,
          );
      if (request.lastDocSnap == null) {
        querySnapshot = await orderByQuery?.limit(10).get();
      } else {
        querySnapshot = await orderByQuery
            ?.startAfterDocument(request.lastDocSnap!)
            .limit(10)
            .get();
      }

      if (querySnapshot == null || querySnapshot.docs.isEmpty) {
        setCrashlyticsCustomKey("collection", request.collection);
        setCrashlyticsCustomKey("orderByField", request.orderByField);
      }
      if (querySnapshot == null) {
        throw Exception("Null Query Snapshot");
      }
      if (querySnapshot.docs.isEmpty) {
        return FirestorePageResponse(
          currentJsonList: [],
          lastDocSnap: null,
        );
      }
     
      return FirestorePageResponse(
        currentJsonList: jsonListFromDocSnaps(querySnapshot),
        lastDocSnap: querySnapshot.docs.last,
      );
    } on PlatformException {
      Fluttertoast.showToast(msg: "No Internet");
    }
  }

  List<Json> jsonListFromDocSnaps(QuerySnapshot<Json> querySnapshot) {
    List<Json> jsonList = [];
    for (var doc in querySnapshot.docs) {
      var data = doc.data();
      data.putIfAbsent("docID", () => doc.id);
      jsonList.add(data);
    }
    return jsonList;
  }
}
