import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_bloc.dart';

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
      contentPaginationCubit.firestore=firebaseFirestore;
    }

    kalaUserStateStream =
        kalaUserBloc.stream.asBroadcastStream().listen((state) {
      if (state is AuthenticatedKalaUserState) {
        getContentList(0);
      }
    });
  }

  final PaginationCubit contentPaginationCubit =
      PaginationCubit.galleryContentPagination();
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

  Future<void> getContentList(int scrollPosition) async {
    final newGalleryContent =
        await contentPaginationCubit.getTList(scrollPosition);

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
