import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kala/acquires_page/widgets/acquires_page.dart';

import 'package:kala/artist_page/widgets/artist_page.dart';
import 'package:kala/gallery/widgets/page/gallery_page.dart';

class DashState {
  final int pageIndex;
  DashState({
    required this.pageIndex,
  });
  final List<Widget> pages = [
    const GalleryPage(),
    const ArtistPage(),
    const AcquiresPage()
  ];

  DashState copyWith({
    int? pageIndex,
  }) {
    return DashState(
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }

  @override
  String toString() => 'DashState(pageIndex: $pageIndex)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashState && other.pageIndex == pageIndex;
  }

  @override
  int get hashCode => pageIndex.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'pageIndex': pageIndex,
    };
  }

  factory DashState.fromMap(Map<String, dynamic> map) {
    return DashState(
      pageIndex: map['pageIndex']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DashState.fromJson(String source) =>
      DashState.fromMap(json.decode(source));
}
