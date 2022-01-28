import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/page_data.dart' show FirestorePageRequest;

@immutable
class GalleryState {
  const GalleryState({
    required this.contentSlideList,
  });

  final List<Content> contentSlideList;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is GalleryState &&
        listEquals(other.contentSlideList, contentSlideList);
  }

  @override
  int get hashCode {
    return contentSlideList.hashCode;
  }

  GalleryState copyWith({
    List<Content>? contentSlideList,
    DocumentSnapshot? lastDocument,
    FirestorePageRequest? lastPageRequest,
    Timestamp? lastFetchedTimestamp,
  }) {
    return GalleryState(
      contentSlideList: contentSlideList ?? this.contentSlideList,
    );
  }
}
