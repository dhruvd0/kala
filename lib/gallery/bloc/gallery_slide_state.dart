import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/page_data.dart';

class GalleryState {
  final List<Content> contentSlideList;

  GalleryState({
    required this.contentSlideList,
  });

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GalleryState &&
        listEquals(other.contentSlideList, contentSlideList);
  }

  @override
  int get hashCode {
    return contentSlideList.hashCode;
  }
}
