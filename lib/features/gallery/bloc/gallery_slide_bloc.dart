import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kala/features/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/features/gallery/art/models/art.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_bloc.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';


class GalleryBloc extends HasPaginationCubit<GalleryState> {
  GalleryBloc()
      : super(
          const GalleryState(
            artSlideList: [],
          ),
          paginationCubit: PaginationCubit.galleryArtPagination(),
        ) {
    // kalaUserStateStream =
    //     kalaUserBloc.stream.asBroadcastStream().listen((state) {
    //   if (state.kalaUserState == UserAuthState.authenticated) {
    //     getArtList(
    //       0,
    //       collectionSegment: CollectionSegment.initial,
    //     );
    //   }
    // });
  }

  @override
  void onChange(Change<GalleryState> change) {
    super.onChange(change);
  }

  Future<void> getArtList(
    int scrollPosition, {
    required CollectionSegment collectionSegment,
  }) async {
    final newGalleryArt = await paginationCubit.getTList(
      scrollPosition,
      segment: collectionSegment,
    );

    if (newGalleryArt.isNotEmpty) {
      emit(
        state.copyWith(
          artSlideList: newGalleryArt.map((dynamic e) => e as Art).toList(),
          lastFetchedTimestamp: Timestamp.now(),
        ),
      );
    }
  }
}
