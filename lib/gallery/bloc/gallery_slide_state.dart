import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';

class GalleryState {
  final List<Content> contentSlideList;
  final DocumentSnapshot? lastDocument;
  GalleryState({
    required this.contentSlideList,
    this.lastDocument
  });

  GalleryState copyWith({
    List<Content>? contentSlideList,
    DocumentSnapshot? lastDocument,
  }) {
    return GalleryState(
      contentSlideList: contentSlideList ?? this.contentSlideList,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }



  @override
  String toString() => 'GalleryState(contentSlideList: $contentSlideList, lastDocument: $lastDocument)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GalleryState &&
      listEquals(other.contentSlideList, contentSlideList) &&
      other.lastDocument == lastDocument;
  }

  @override
  int get hashCode => contentSlideList.hashCode ^ lastDocument.hashCode;
}
