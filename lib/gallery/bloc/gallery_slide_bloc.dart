import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:kala/auth/bloc/kala_user_bloc.dart';

import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/models/content.dart';
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

  Future<void> cacheContentImages(BuildContext context) async {
    for (final content in state.contentSlideList) {
      if (content.isValid()) {
        await precacheImage(
          CachedNetworkImageProvider(
            content.imageUrl.toString(),
            cacheKey: content.imageUrl.toString(),
            cacheManager: DefaultCacheManager(),
            errorListener: () {
              //
            },
          ),
          context,
          size: Size(1.sw - 10, 200),
          onError: (e, stack) {
            log(e.toString());
            if (kDebugMode && (e is Exception)) {
              throw e;
            }
          },
        );
      }
    }
  }
}
