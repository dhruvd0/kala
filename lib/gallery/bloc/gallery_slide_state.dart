
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/page_data.dart';

class GalleryState {
  final List<Content> contentSlideList;
  final DocumentSnapshot? lastDocument;
  final FirestorePageRequest? lastPageRequest;
  GalleryState({
    required this.contentSlideList,
    this.lastDocument,
     this.lastPageRequest,
  });

  GalleryState copyWith({
    List<Content>? contentSlideList,
    DocumentSnapshot? lastDocument,
    FirestorePageRequest? lastPageRequest,
  }) {
    return GalleryState(
      contentSlideList: contentSlideList ?? this.contentSlideList,
      lastDocument: lastDocument ?? this.lastDocument,
      lastPageRequest: lastPageRequest ?? this.lastPageRequest,
    );
  }

  @override
  String toString() => 'GalleryState(contentSlideList: $contentSlideList, lastDocument: $lastDocument, lastPageRequest: $lastPageRequest)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GalleryState &&
      listEquals(other.contentSlideList, contentSlideList) &&
      other.lastDocument == lastDocument &&
      other.lastPageRequest == lastPageRequest;
  }

  @override
  int get hashCode => contentSlideList.hashCode ^ lastDocument.hashCode ^ lastPageRequest.hashCode;

  
}
