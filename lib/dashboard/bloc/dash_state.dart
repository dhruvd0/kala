import 'package:flutter/material.dart';
import 'package:kala/acquires_page/widgets/acquires_page.dart';

import 'package:kala/artist_page/widgets/artist_page.dart';
import 'package:kala/gallery/widgets/page/gallery_page.dart';

@immutable
class DashState {
  DashState({
    required this.pageIndex,
  });

  final int pageIndex;
  final List<Widget> pages = [
    const GalleryPage(),
    const ArtistPage(),
    const AcquiresPage()
  ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DashState && other.pageIndex == pageIndex;
  }

  @override
  int get hashCode => pageIndex.hashCode;

  @override
  String toString() => 'DashState(pageIndex: $pageIndex)';

  DashState copyWith({
    int? pageIndex,
  }) {
    return DashState(
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }
}
