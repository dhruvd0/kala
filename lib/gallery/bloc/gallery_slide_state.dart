import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';

class GalleryState {
  final List<Content> contentSlideList;

  GalleryState({
    required this.contentSlideList,
  });

  GalleryState copyWith({
    List<Content>? contentSlideList,
  }) {
    return GalleryState(
      contentSlideList: contentSlideList ?? this.contentSlideList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contentSlideList': contentSlideList.map((x) => x.toMap()).toList(),
    };
  }

  factory GalleryState.fromMap(Map<String, dynamic> map) {
    return GalleryState(
      contentSlideList: List<Content>.from(map['contentSlideList']?.map((x) => Content.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory GalleryState.fromJson(String source) =>
      GalleryState.fromMap(json.decode(source));

  @override
  String toString() => 'GalleryState(contentSlideList: $contentSlideList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GalleryState &&
      listEquals(other.contentSlideList, contentSlideList);
  }

  @override
  int get hashCode => contentSlideList.hashCode;

  static GalleryState fakeGalleryState() {
    return GalleryState(
      
      contentSlideList: List.generate(
        20,
        (index) => Content.fakeContent(index),
      ),
    );
  }
}
