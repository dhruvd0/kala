// ignore_for_file: avoid_single_cascade_in_expression_statements, prefer_final_locals, cascade_invocations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/firestore_get.dart';
import 'package:kala/utils/firebase/page_data.dart';
import 'package:kala/utils/helper_bloc/content_pagination/content_pagination_state.dart';

class ContentPaginationCubit extends Cubit<ContentPaginationState> {
  ContentPaginationCubit({
    required String collection,
    required bool orderIsDescending,
    required String orderByField,
    this.firebaseFirestore,
  }) : super(
          ContentPaginationState(
            collection: collection,
            orderIsDescending: orderIsDescending,
            orderByField: orderByField,
            lastFetchedTimestamp: Timestamp.now(),
            content: const [],
          ),
        );

  FirebaseFirestore? firebaseFirestore;

  Future<List<Content>> getContentList() async {
    final firestorePageRequest = FirestorePageRequest(
      collection: state.collection,
      orderByField: state.orderByField,
      lastDocSnap: state.lastDocument,
      orderIsDescending: state.orderIsDescending,
    );
    if (state.lastPageRequest == firestorePageRequest) {
      return [];
    }
    emit(state.copyWith(lastPageRequest: firestorePageRequest));
    final response = await FirestoreQueries(firestore: firebaseFirestore)
        .paginateCollectionDocuments(firestorePageRequest);
    if (response == null) {
      return [];
    }
    emit(
      state.copyWith(
        lastDocument: response.lastDocSnap,
      ),
    );

    final validatedContent = validateAndEmitContent(
      parseContentFromFirestoreResponse(<dynamic>[
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
      // ignore: omit_local_variable_types
      List<Content> currentContentList = state.content.toList(growable: true);
      currentContentList.addAll(newContentList);

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
