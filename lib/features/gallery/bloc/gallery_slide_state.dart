import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/features/gallery/art/models/art.dart';

abstract class GalleryState extends Equatable {}

@immutable
class FetchedGalleryState extends GalleryState {
  FetchedGalleryState({
    required this.artSlideList,
  });

  final List<Art> artSlideList;

  GalleryState copyWith({
    List<Art>? artSlideList,
  }) {
    return FetchedGalleryState(
      artSlideList: artSlideList ?? this.artSlideList,
    );
  }

  @override
  List<Object?> get props => [artSlideList];
}

class InititalGalleryState extends FetchedGalleryState {
  InititalGalleryState() : super(artSlideList: []);
}

class LoadingGalleryState extends GalleryState {
  @override
  List<Object?> get props => [];
}
