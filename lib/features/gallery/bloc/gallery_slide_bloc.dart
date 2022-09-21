import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kala/features/auth/bloc/kala_user_bloc.dart';

import 'package:kala/features/auth/models/kala_user.dart';
import 'package:kala/features/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/features/gallery/content/models/content.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_bloc.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

class GalleryBloc extends HasPaginationCubit<GalleryState> {
  GalleryBloc({
    required KalaUserBloc kalaUserBloc,
  }) : super(
          const GalleryState(
            contentSlideList: [],
          ),
          paginationCubit: PaginationCubit.galleryContentPagination(),
        ) {
    kalaUserStateStream =
        kalaUserBloc.stream.asBroadcastStream().listen((state) {
      if (state.kalaUserState == KalaUserState.authenticated) {
        getContentList(
          0,
          collectionSegment: CollectionSegment.initial,
        );
      }
    });
  }

  StreamSubscription<KalaUser>? kalaUserStateStream;

  @override
  Future<void> close() async {
    await kalaUserStateStream?.cancel();
    return super.close();
  }

  @override
  void onChange(Change<GalleryState> change) {
    super.onChange(change);
  }

  Future<void> getContentList(
    int scrollPosition, {
    required CollectionSegment collectionSegment,
  }) async {
    final newGalleryContent = await paginationCubit.getTList(
      scrollPosition,
      segment: collectionSegment,
    );

    if (newGalleryContent.isNotEmpty) {
      emit(
        state.copyWith(
          contentSlideList:
              newGalleryContent.map((dynamic e) => e as Content).toList(),
          lastFetchedTimestamp: Timestamp.now(),
        ),
      );
    }
  }
}
