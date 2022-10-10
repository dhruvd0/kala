import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/features/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/features/gallery/repositories/gallery_repository.dart';

class GalleryBloc extends Cubit<GalleryState> {
  GalleryBloc(this._galleryRepository)
      : super(
          InititalGalleryState(),
        );

  final GalleryRepository _galleryRepository;

  Future<void> getArtList([int scrollPosition = 0]) async {
    if (state is InititalGalleryState) {
      emit(LoadingGalleryState());
    }

    final newGalleryArt =
        await _galleryRepository.getGalleryArt(scrollPosition);
    if (state is FetchedGalleryState) {
      emit(
        (state as FetchedGalleryState).copyWith(
          artSlideList: scrollPosition == 0
              ? [
                  ...newGalleryArt,
                  ...(state as FetchedGalleryState).artSlideList,
                ]
              : [
                  ...(state as FetchedGalleryState).artSlideList,
                  ...newGalleryArt
                ],
        ),
      );
    } else {
      emit(FetchedGalleryState(artSlideList: newGalleryArt));
    }
  }
}
