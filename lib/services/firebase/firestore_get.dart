import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/config/typedefs.dart';
import 'package:kala/services/firebase/crashlytics.dart';
import 'package:kala/services/firebase/page_data.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

class FirestoreQueries {
  FirestoreQueries();
  FirebaseFirestore firestore = getIt.get<FirebaseConfig>().firestore;

  Future<FirestorePageResponse?> paginateCollectionDocuments(
    PaginationRequestState request, {
    CollectionSegment? collectionSegment,
  }) async {
    // ignore: lines_longer_than_80_chars
    try {
      QuerySnapshot? querySnapshot;
      final collection = firestore.collection(request.collection);

      Query? baseQuery = collection;
      if (request.whereQueryEquals != null &&
          (request.whereQueryEquals!.keys.isNotEmpty)) {
        final field = request.whereQueryEquals!.keys.first;
        final value = request.whereQueryEquals![field];
        baseQuery = baseQuery.where(field, isEqualTo: value.toString());
      }
      baseQuery = baseQuery.orderBy(
        request.orderByField,
        descending: request.orderIsDescending,
      );

      querySnapshot = await getQueryForCollectionSegment(
        collectionSegment,
        baseQuery,
        request,
      );

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
          firstDocSnap: null,
        );
      }

      final jsonListFromDocSnaps2 = jsonListFromDocSnaps(querySnapshot);
      //log("Count: ${jsonListFromDocSnaps2.length} ,
      // First:${querySnapshot.docs.first.id},
      // Last:${querySnapshot.docs.last.id}  ");
      return FirestorePageResponse(
        currentJsonList: jsonListFromDocSnaps2,
        lastDocSnap: querySnapshot.docs.last,
        firstDocSnap: querySnapshot.docs.first,
      );
    } on PlatformException {
      await Fluttertoast.showToast(msg: 'No Internet');
      return null;
    }
  }

  Future<QuerySnapshot?> getQueryForCollectionSegment(
    CollectionSegment? collectionSegment,
    Query? baseQuery,
    PaginationRequestState request,
  ) async {
    switch (collectionSegment) {
      case null:
        return await baseQuery?.limit(10).get();

      case CollectionSegment.initial:
        return await baseQuery?.limit(10).get();

      case CollectionSegment.previous:
        if (request.firstDocument == null) {
          return await baseQuery?.limit(10).get();
        }
        return await baseQuery
            ?.endBeforeDocument(request.firstDocument!)
            .limit(10)
            .get();

      case CollectionSegment.next:
        assert(request.lastDocument != null);
        return await baseQuery
            ?.startAfterDocument(request.lastDocument!)
            .limit(10)
            .get();
    }
  }

  List<Json> jsonListFromDocSnaps(QuerySnapshot querySnapshot) {
    final jsonList = <Json>[];
    for (final doc in querySnapshot.docs) {
      final docData = doc.data();
      if (docData == null) {
        continue;
      }
      // ignore: prefer_final_locals
      var jsonData = docData as Map<String, dynamic>;

      jsonList.add(jsonData);
    }
    return jsonList;
  }
}
