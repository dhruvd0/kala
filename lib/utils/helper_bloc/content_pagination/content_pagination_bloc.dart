import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/firestore_get.dart';
import 'package:kala/utils/firebase/page_data.dart';
import 'package:kala/utils/helper_bloc/content_pagination/content_pagination_state.dart';

class ContentPaginationCubit extends Cubit<ContentPaginationState> {
  FirebaseFirestore? firebaseFirestore;
  ContentPaginationCubit({
    this.firebaseFirestore,
    required String collection,
    required bool orderIsDescending,
    required String orderByField,
  }) : super(
          ContentPaginationState(
            collection: collection,
            orderIsDescending: orderIsDescending,
            orderByField: orderByField,
            lastFetchedTimestamp: Timestamp.now(),
            content: [],
          ),
        );

  Future<List<Content>> getContentList() async {
    var firestorePageRequest = FirestorePageRequest(
      collection: state.collection,
      orderByField: state.orderByField,
      lastDocSnap: state.lastDocument,
      orderIsDescending: state.orderIsDescending,
    );
    if (state.lastPageRequest == firestorePageRequest) {
      return [];
    }
    emit(state.copyWith(lastPageRequest: firestorePageRequest));
    FirestorePageResponse? response =
        await FirestoreQueries(firestore: firebaseFirestore)
            .paginateCollectionDocuments(firestorePageRequest);
    if (response == null) {
      return [];
    }
    emit(state.copyWith(
      lastDocument: response.lastDocSnap,
    ));

    var validatedContent = validateAndEmitContent(
      parseContentFromFirestoreResponse([
        response,
        state.content,
      ]),
      response,
    );
    return validatedContent;
  }

  List<Content> validateAndEmitContent(
    List<Content> newContentList,
    FirestorePageResponse response,
  ) {
    if (newContentList.isNotEmpty) {
      var currentContentList = state.content;

      currentContentList.addAll(newContentList);
      log(" Last:${currentContentList.last.docID}  ");
      emit(
        state.copyWith(
          content: currentContentList,
          lastFetchedTimestamp: Timestamp.now(),
        ),
      );
      return currentContentList;
    } else {
      return [];
    }
  }

  void assertionsForNewContentList(List<Content> newContentList) {
    assert(state.content.last.docID != newContentList.first.docID);
  }
}
