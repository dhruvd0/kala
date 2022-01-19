import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/crashlytics.dart';
import 'package:kala/utils/firebase/firestore_get.dart';
import 'package:kala/utils/firebase/page_data.dart';

List<Content> parseContentFromFirestoreResponse(List<dynamic> args) {
  log("IN ISOLATE:${Isolate.current}");
  List<Content> newContentList = [];
  FirestorePageResponse response = args.first;
  for (var jsonElement in response.currentJsonList) {
    try {
      assert(jsonElement.containsKey("docID"));
      newContentList.add(Content.fromMap(jsonElement));
    } on AssertionError {}
  }
  var currentContentList = args.last;
  if (newContentList.isNotEmpty && currentContentList.isNotEmpty) {
    newContentList.removeWhere(
      (newE) => currentContentList.any(
        ((element) => newE.docID == element.docID),
      ),
    );
  }

  return newContentList;
}

class GalleryBloc extends Cubit<GalleryState> {
  StreamSubscription<KalaUserState>? kalaUserStateStream;
  FirebaseFirestore? firebaseFirestore;

  GalleryBloc({required KalaUserBloc kalaUserBloc, this.firebaseFirestore})
      : super(GalleryState(
            contentSlideList: [], lastFetchedTimestamp: Timestamp.now())) {
    kalaUserStateStream =
        kalaUserBloc.stream.asBroadcastStream().listen((state) {
      if (state is AuthenticatedKalaUserState) {
        getContentList();
      }
    });
  }
  @override
  void onChange(Change<GalleryState> change) {
    // TODO: implement onChange
    super.onChange(change);
    
  }

  @override
  Future<void> close() async {
    await kalaUserStateStream?.cancel();
    return super.close();
  }

  Future<void> getContentList() async {
    var firestorePageRequest = FirestorePageRequest(
      collection: FirestorePaths.fakeContentCollection,
      orderByField: "uploadTimestamp",
      lastDocSnap: state.lastDocument,
      orderIsDescending: true,
    );
    if (state.lastPageRequest == firestorePageRequest) {
      return;
    }
    emit(state.copyWith(lastPageRequest: firestorePageRequest));
    FirestorePageResponse? response =
        await FirestoreQueries(firestore: firebaseFirestore)
            .paginateCollectionDocuments(firestorePageRequest);
    if (response == null) {
      return;
    }
    emit(state.copyWith(
      lastDocument: response.lastDocSnap,
    ));

    validateAndEmitContent(
      parseContentFromFirestoreResponse([
        response,
        state.contentSlideList,
      ]),
      response,
    );
  }

  void validateAndEmitContent(
    List<Content> newContentList,
    FirestorePageResponse response,
  ) {
    if (newContentList.isNotEmpty) {
      var currentContentList = state.contentSlideList;

      currentContentList.addAll(newContentList);

      emit(state.copyWith(
        contentSlideList: currentContentList,
        lastDocument: response.lastDocSnap,
      ));
      emit(state.copyWith(lastFetchedTimestamp: Timestamp.now()));
    }
  }

  void assertionsForNewContentList(List<Content> newContentList) {
    assert(state.contentSlideList.last.docID != newContentList.first.docID);
  }
}
