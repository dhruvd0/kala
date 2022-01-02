import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kala/gallery/content/models/content.dart';



class GallerySlideState {
  final List<Content> contentSlideList;
  GallerySlideState({
    required this.contentSlideList,
  });

  GallerySlideState copyWith({
    List<Content>? contentSlideList,
  }) {
    return GallerySlideState(
      contentSlideList: contentSlideList ?? this.contentSlideList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contentSlideList': contentSlideList.map((x) => x.toMap()).toList(),
    };
  }

  factory GallerySlideState.fromMap(Map<String, dynamic> map) {
    return GallerySlideState(
      contentSlideList: List<Content>.from(
          map['contentSlideList']?.map((x) => Content.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory GallerySlideState.fromJson(String source) =>
      GallerySlideState.fromMap(json.decode(source));

  @override
  String toString() => 'GallerySlideState(contentSlideList: $contentSlideList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GallerySlideState &&
        listEquals(other.contentSlideList, contentSlideList);
  }

  @override
  int get hashCode => contentSlideList.hashCode;

  static GallerySlideState fakeGalleryState() {
    return GallerySlideState(
      contentSlideList: List.generate(
        20,
        (index) => Content.fakeContent(index),
      ),
    );
  }


}
