import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/typedefs.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/crashlytics.dart';
import 'package:kala/utils/firebase/firestore_get.dart';
import 'package:kala/utils/firebase/page_data.dart';

class GalleryBloc extends Cubit<GalleryState> {
  StreamSubscription<KalaUserState>? kalaUserStateStream;
  FirebaseFirestore? firebaseFirestore;

  GalleryBloc({required KalaUserBloc kalaUserBloc, this.firebaseFirestore})
      : super(GalleryState(contentSlideList: [])) {
    kalaUserStateStream =
        kalaUserBloc.stream.asBroadcastStream().listen((state) {
      if (state is AuthenticatedKalaUserState) {
        getContentList();
      }
    });
  }
  @override
  Future<void> close() async {
    await kalaUserStateStream?.cancel();
    return super.close();
  }

  Future<void> getContentList() async {
    var firestorePageRequest = FirestorePageRequest(
      collection: FirestorePaths.contentCollection,
      orderByField: "uploadTimestamp",
      lastDocSnap: state.lastDocument,
      orderIsDescending: true,
    );
    if (state.lastPageRequest == firestorePageRequest) {
      return;
    }
    FirestorePageResponse? response =
        await FirestoreQueries(firestore: firebaseFirestore)
            .paginateCollectionDocuments(firestorePageRequest);
    if (response == null) {
      return;
    }
    emit(state.copyWith(lastPageRequest: firestorePageRequest));

    parseContentFromFirestoreResponse(response);
  }

  void parseContentFromFirestoreResponse(FirestorePageResponse response) {
    List<Content> newContentList = [];
    for (var jsonElement in response.currentJsonList) {
      try {
        assert(jsonElement.containsKey("docID"));
        newContentList.add(Content.fromMap(jsonElement));
      } on AssertionError {
        setCrashlyticsCustomKey(
          "content",
          jsonElement["docID"],
        ).then(
          (value) => throw Exception(
              "Content Validation Exception ${jsonElement["docID"]}"),
        );
      } catch (e) {
        setCrashlyticsCustomKey(
          "content#${jsonElement['docID']}",
          jsonElement,
        ).then(
          (value) => throw Exception(
            "Content.fromMap Parse Exception, Content:${jsonElement['docID']}",
          ),
        );
      }
    }

    validateAndEmitContent(
      newContentList,
      response,
    );
  }

  void validateAndEmitContent(
    List<Content> newContentList,
    FirestorePageResponse response,
  ) {
    if (newContentList.isNotEmpty) {
      try {
        if (state.contentSlideList.isNotEmpty) {
          assertionsForNewContentList(newContentList);
        }
        
        var currentContentList = state.contentSlideList;
        currentContentList.addAll(newContentList);
        emit(state.copyWith(
          contentSlideList: currentContentList,
          lastDocument: response.lastDocSnap,
        ));
      } on AssertionError catch (e) {
        // TODO
      }
    }
  }

  void assertionsForNewContentList(List<Content> newContentList) {
    assert(state.contentSlideList.last.docID != newContentList.first.docID);
    assert(state.contentSlideList.last.docID != newContentList.last.docID);
    assert(state.contentSlideList.first.docID != newContentList.first.docID);
  }
}
