import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/typedefs.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/crashlytics.dart';
import 'package:kala/utils/firebase/firestore_get.dart';

class GalleryBloc extends Cubit<GalleryState> {
  StreamSubscription<KalaUserState>? kalaUserStateStream;
  FirebaseFirestore? firebaseFirestore;
  GalleryBloc({required KalaUserBloc kalaUserBloc,this.firebaseFirestore})
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
    List<Json> contentJson = await FirestoreQueries(firestore: firebaseFirestore).getAllCollectionDocuments(
      FirestorePaths.contentCollection,
      orderByField: "docID",
    );
    List<Content> contentList = [];
    for (var jsonElement in contentJson) {
      try {
        assert(jsonElement.containsKey("docID"));
        contentList.add(Content.fromMap(jsonElement));
      } on AssertionError {
        setCrashlyticsCustomKey("content", jsonElement["docID"]).then(
          (value) => throw Exception(
              "Content Validation Exception ${jsonElement["docID"]}"),
        );
      } catch (e) {
        setCrashlyticsCustomKey(
                "content#${jsonElement['docID']}", jsonElement)
            .then(
          (value) => throw Exception(
            "Content.fromMap Parse Exception, Content:${jsonElement['docID']}",
          ),
        );
      }
    }
    if (contentList.isNotEmpty) {
      emit(state.copyWith(contentSlideList: contentList));
    }
  }
}
