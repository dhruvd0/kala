import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/features/gallery/art/models/art.dart';
import 'package:kala/features/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/features/gallery/repositories/gallery_repository.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

class GalleryBloc extends Cubit<GalleryState> {
  GalleryBloc(this.galleryRepository)
      : super(
          const GalleryState(
            artSlideList: [],
          ),
        );

  final GalleryRepository galleryRepository;

  Future<void> getArtList(
    int scrollPosition, {
    required CollectionSegment collectionSegment,
  }) async {
    final newGalleryArt = await galleryRepository.getGalleryArt(
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
