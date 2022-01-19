import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/page_data.dart';

class GalleryState {
  final List<Content> contentSlideList;
  final DocumentSnapshot? lastDocument;
  final FirestorePageRequest? lastPageRequest;
  final Timestamp lastFetchedTimestamp;
  GalleryState({
    required this.contentSlideList,
    this.lastDocument,
    this.lastPageRequest,
    required this.lastFetchedTimestamp,
  });

  GalleryState copyWith({
    List<Content>? contentSlideList,
    DocumentSnapshot? lastDocument,
    FirestorePageRequest? lastPageRequest,
    Timestamp? lastFetchedTimestamp,
  }) {
    return GalleryState(
      contentSlideList: contentSlideList ?? this.contentSlideList,
      lastDocument: lastDocument ?? this.lastDocument,
      lastPageRequest: lastPageRequest ?? this.lastPageRequest,
      lastFetchedTimestamp: lastFetchedTimestamp ?? this.lastFetchedTimestamp,
    );
  }

  @override
  String toString() {
    return 'GalleryState(contentSlideList: $contentSlideList, lastDocument: $lastDocument, lastPageRequest: $lastPageRequest, lastFetchedTimestamp: $lastFetchedTimestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GalleryState &&
        listEquals(other.contentSlideList, contentSlideList) &&
        other.lastDocument == lastDocument &&
        other.lastPageRequest == lastPageRequest &&
        other.lastFetchedTimestamp == lastFetchedTimestamp;
  }

  @override
  int get hashCode {
    return contentSlideList.hashCode ^
        lastDocument.hashCode ^
        lastPageRequest.hashCode ^
        lastFetchedTimestamp.hashCode;
  }
}
