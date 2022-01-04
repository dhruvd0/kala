import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';

class GallerySlideState {
  final List<Content> contentSlideList;
  final int viewingIndex;
  GallerySlideState({
    required this.contentSlideList,
    required this.viewingIndex,
  });

  GallerySlideState copyWith({
    List<Content>? contentSlideList,
    int? viewingIndex,
  }) {
    return GallerySlideState(
      contentSlideList: contentSlideList ?? this.contentSlideList,
      viewingIndex: viewingIndex ?? this.viewingIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contentSlideList': contentSlideList.map((x) => x.toMap()).toList(),
      'viewingIndex': viewingIndex,
    };
  }

  factory GallerySlideState.fromMap(Map<String, dynamic> map) {
    return GallerySlideState(
      contentSlideList: List<Content>.from(map['contentSlideList']?.map((x) => Content.fromMap(x))),
      viewingIndex: map['viewingIndex']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GallerySlideState.fromJson(String source) =>
      GallerySlideState.fromMap(json.decode(source));

  @override
  String toString() => 'GallerySlideState(contentSlideList: $contentSlideList, viewingIndex: $viewingIndex)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GallerySlideState &&
      listEquals(other.contentSlideList, contentSlideList) &&
      other.viewingIndex == viewingIndex;
  }

  @override
  int get hashCode => contentSlideList.hashCode ^ viewingIndex.hashCode;

  static GallerySlideState fakeGalleryState() {
    return GallerySlideState(
      viewingIndex: 0,
      contentSlideList: List.generate(
        20,
        (index) => Content.fakeContent(index),
      ),
    );
  }
}
