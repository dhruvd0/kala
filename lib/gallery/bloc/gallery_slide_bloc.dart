import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/crashlytics.dart';
import 'package:kala/utils/firebase/page_data.dart';
import 'package:kala/utils/helper_bloc/content_pagination/content_pagination_bloc.dart';

List<Content> parseContentFromFirestoreResponse(List<dynamic> args) {
  final newContentList = <Content>[];
  final response = args.first as FirestorePageResponse;
  for (final jsonElement in response.currentJsonList) {
    try {
      assert(jsonElement.containsKey('docID'));
      newContentList.add(Content.fromMap(jsonElement));
      // ignore: avoid_catching_errors
    } on AssertionError {
      setCrashlyticsCustomKey('doc', jsonElement)
          .then((value) => throw Exception('No docID'));
    }
  }
  final currentContentList = args.last as List<Content>;
  if (newContentList.isNotEmpty && currentContentList.isNotEmpty) {
    newContentList.removeWhere(
      (newE) => currentContentList.any(
        (element) => newE.docID == element.docID,
      ),
    );
  }

  return newContentList;
}

class GalleryBloc extends Cubit<GalleryState> {
  GalleryBloc({
    required KalaUserBloc kalaUserBloc,
    required this.contentPaginationCubit,
  }) : super(
          const GalleryState(
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

  final ContentPaginationCubit contentPaginationCubit;
  StreamSubscription<KalaUserState>? kalaUserStateStream;

  @override
  Future<void> close() async {
    await kalaUserStateStream?.cancel();
    return super.close();
  }

  @override
  void onChange(Change<GalleryState> change) {
    super.onChange(change);
  }

  Future<void> getContentList() async {
    final newGalleryContent = await contentPaginationCubit.getContentList();

    if (newGalleryContent.isNotEmpty) {
      emit(
        state.copyWith(
          contentSlideList: newGalleryContent,
          lastFetchedTimestamp: Timestamp.now(),
        ),
      );
    }
  }
}
