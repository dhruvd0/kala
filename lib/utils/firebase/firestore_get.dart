import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kala/config/typedefs.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/firebase/crashlytics.dart';
import 'package:kala/utils/firebase/page_data.dart';

class FirestoreQueries {
  FirestoreQueries({this.firestore}) {
    firestore = firestore ?? firebaseConfig!.firestore;
  }

  FirebaseFirestore? firestore;

  Future<FirestorePageResponse?> paginateCollectionDocuments(
    FirestorePageRequest request,
  ) async {
    try {
      QuerySnapshot<Json>? querySnapshot;
      final orderByQuery = firestore?.collection(request.collection).orderBy(
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
        await setCrashlyticsCustomKey('collection', request.collection);
        await setCrashlyticsCustomKey('orderByField', request.orderByField);
      }
      if (querySnapshot == null) {
        throw Exception('Null Query Snapshot');
      }
      if (querySnapshot.docs.isEmpty) {
        return const FirestorePageResponse(
          currentJsonList: [],
          lastDocSnap: null,
        );
      }

      final jsonListFromDocSnaps2 = jsonListFromDocSnaps(querySnapshot);
      //log("Count: ${jsonListFromDocSnaps2.length} , First:${querySnapshot.docs.first.id}, Last:${querySnapshot.docs.last.id}  ");
      return FirestorePageResponse(
        currentJsonList: jsonListFromDocSnaps2,
        lastDocSnap: querySnapshot.docs.last,
      );
    } on PlatformException {
      await Fluttertoast.showToast(msg: 'No Internet');
    }
  }

  List<Json> jsonListFromDocSnaps(QuerySnapshot<Json> querySnapshot) {
    final jsonList = <Json>[];
    for (final doc in querySnapshot.docs) {
      final data = doc.data()..putIfAbsent('docID', () => doc.id);
      jsonList.add(data);
    }
    return jsonList;
  }
}
