import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/features/gallery/art/models/art.dart';

@immutable
class GalleryState {
  const GalleryState({
    required this.artSlideList,
  });

  final List<Art> artSlideList;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is GalleryState &&
        listEquals(other.artSlideList, artSlideList);
  }

  @override
  int get hashCode {
    return artSlideList.hashCode;
  }

  GalleryState copyWith({
    List<Art>? artSlideList,
    DocumentSnapshot? lastDocument,
    Timestamp? lastFetchedTimestamp,
  }) {
    return GalleryState(
      artSlideList: artSlideList ?? this.artSlideList,
    );
  }
}
