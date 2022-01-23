import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/config/typedefs.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/firebase/crashlytics.dart';
import 'package:kala/utils/firebase/page_data.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

class FirestoreQueries {
  FirestoreQueries({this.firestore}) {
    firestore =
        firestore ?? firebaseConfig?.firestore ?? FirebaseMocks.mockFirestore;
  }

  FirebaseFirestore? firestore;

  Future<FirestorePageResponse?> paginateCollectionDocuments(
    PaginationRequestState request,
  ) async {
    try {
      QuerySnapshot? querySnapshot;
      final collection = firestore?.collection(request.collection);

      Query? baseQuery = collection?.where(FieldPath.documentId, isNull: false);
      if (request.whereQueryEquals != null &&
          (request.whereQueryEquals?.keys.isNotEmpty ?? false)) {
        final field = request.whereQueryEquals?.keys.first;
        final value = request.whereQueryEquals?[field];
        baseQuery = collection?.where(field!, isEqualTo: value.toString());
      }
      final orderByQuery = baseQuery?.orderBy(
        request.orderByField,
        descending: request.orderIsDescending,
      );
      if (request.lastDocument == null) {
        querySnapshot = await orderByQuery?.limit(10).get();
      } else {
        querySnapshot = await orderByQuery
            ?.startAfterDocument(request.lastDocument!)
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

  List<Json> jsonListFromDocSnaps(QuerySnapshot querySnapshot) {
    final jsonList = <Json>[];
    for (final doc in querySnapshot.docs) {
      final docData = doc.data();
      if (docData == null) {
        continue;
      }
      final jsonData = docData as Map<String, dynamic>;
      final data = jsonData..putIfAbsent('docID', () => doc.id);
      jsonList.add(data);
    }
    return jsonList;
  }
}
