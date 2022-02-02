import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kala/auth/bloc/kala_user_bloc.dart';

import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_bloc.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

class GalleryBloc extends Cubit<GalleryState> {
  GalleryBloc({
    required KalaUserBloc kalaUserBloc,
    FirebaseFirestore? firebaseFirestore,
  }) : super(
          const GalleryState(
            contentSlideList: [],
          ),
        ) {
    if (firebaseFirestore != null) {
      contentPaginationCubit.firestore = firebaseFirestore;
    }

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

  final PaginationCubit contentPaginationCubit =
      PaginationCubit.galleryContentPagination();
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
    final newGalleryContent = await contentPaginationCubit
        .getTList(scrollPosition, segment: collectionSegment);

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

//   Future<void> cacheContentImages() {
//     state.contentSlideList.forEach((e) {
//       if(e.isValid()){
// CachedNetworkImageProvider(
//           widget.image.toString(),
//           cacheKey: widget.image.toString(),
//           cacheManager: DefaultCacheManager(),
//           errorListener: () {
//             imageProvider = null;
//           },
//         );
//       }

//     });

//   }
}
