import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:kala/utils/helper_bloc/content_pagination/content_pagination_bloc.dart';

List<Content> parseContentFromFirestoreResponse(List<dynamic> args) {
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

  final ContentPaginationCubit contentPaginationCubit;
  GalleryBloc({
    required KalaUserBloc kalaUserBloc,
    required this.contentPaginationCubit,
  }) : super(
          GalleryState(
            contentSlideList: [],
          ),
        ) {
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
    List<Content> newGalleryContent =
        (await contentPaginationCubit.getContentList());

    if (newGalleryContent.isNotEmpty) {
      emit(state.copyWith(
        contentSlideList: newGalleryContent,
        lastFetchedTimestamp: Timestamp.now(),
      ));
    }
  }
}
