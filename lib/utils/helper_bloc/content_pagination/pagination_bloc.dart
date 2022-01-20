// ignore_for_file: avoid_single_cascade_in_expression_statements, prefer_final_locals, cascade_invocations

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/firebase/firestore_paths.dart';

import 'package:kala/config/typedefs.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/crashlytics.dart';
import 'package:kala/utils/firebase/firestore_get.dart';
import 'package:kala/utils/firebase/page_data.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

class PaginationCubit extends Cubit<PaginationRequestState> {
  PaginationCubit({
    required String collection,
    required bool orderIsDescending,
    required String orderByField,
    required this.dataFromMap,
    this.firebaseFirestore,
    String? subCollection,
    String? subDocID,
  }) : super(
          PaginationRequestState(
            collection: collection,
            orderIsDescending: orderIsDescending,
            orderByField: orderByField,
            subCollection: subCollection,
            subDocID: subDocID,
            lastFetchedTimestamp: Timestamp.now(),
            data: const <dynamic>[],
          ),
        );
  factory PaginationCubit.galleryContentPagination(){
    return PaginationCubit(
      collection: FirestorePaths.fakeContentCollection,
      orderIsDescending: true,
      dataFromMap: Content.fromMap,
      orderByField: 'uploadTimestamp',
    );
  }
  factory PaginationCubit.userContentPagination(String uid){
    return PaginationCubit(
      collection: FirestorePaths.userCollection,
      orderIsDescending: true,
      orderByField: 'uploadTimestamp',
      dataFromMap: Content.fromMap,
      subCollection: FirestorePaths.userPaths.userContent,
      subDocID: uid,
    );
  }

  final dynamic Function(Map<String, dynamic>) dataFromMap;
  FirebaseFirestore? firebaseFirestore;

  Future<List<dynamic>> getTList(int scrollPosition) async {
    final firestorePageRequest = state;
    if (scrollPosition == state.scrollPosition) {
      return <dynamic>[];
    }
    emit(state.copyWith(scrollPosition: scrollPosition));
    final response = await FirestoreQueries(firestore: firebaseFirestore)
        .paginateCollectionDocuments(firestorePageRequest);
    if (response == null) {
      return <dynamic>[];
    }
    emit(
      state.copyWith(
        lastDocument: response.lastDocSnap,
      ),
    );

    final validatedData = validateAndEmitData(
      parseTListFromFirestoreResponse(<dynamic>[
        response,
        state.data,
      ]),
      response,
    );
    return validatedData;
  }

  List<dynamic> parseTListFromFirestoreResponse(List<dynamic> args) {
    final newContentList = <dynamic>[];
    final response = args.first as FirestorePageResponse;
    for (final jsonElement in response.currentJsonList) {
      try {
        assert(jsonElement.containsKey('docID'));
        newContentList.add(dataFromMap(jsonElement));
        // ignore: avoid_catching_errors
      } on AssertionError {
        setCrashlyticsCustomKey('doc', jsonElement)
            .then((value) => throw Exception('No docID'));
      }
    }
    final currentList = args.last as List<dynamic>;
    if (newContentList.isNotEmpty && currentList.isNotEmpty) {
      newContentList.removeWhere(
        (dynamic newE) => currentList.any(
          (dynamic element) => newE == element,
        ),
      );
    }

    return newContentList;
  }

  List<dynamic> validateAndEmitData(
    List<dynamic> newDataList,
    FirestorePageResponse response,
  ) {
    if (newDataList.isNotEmpty) {
      // ignore: omit_local_variable_types
      var currentDataList = state.data.toList();
      newDataList.forEach((dynamic e) => currentDataList.add(e));

      emit(
        state.copyWith(
          data: currentDataList,
          lastFetchedTimestamp: Timestamp.now(),
        ),
      );
      return currentDataList;
    } else {
      return <dynamic>[];
    }
  }

  void assertionsForNewDataList(List<dynamic> newDataList) {
    assert(state.data.last != newDataList.first);
  }

  void changeFirestore(FirebaseFirestore firebaseFirestore) {
    this.firebaseFirestore = firebaseFirestore;
  }
}
