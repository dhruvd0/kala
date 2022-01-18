import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kala/artist_page/widgets/artist_page.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_container.dart';

import 'package:kala/gallery/widgets/page/gallery_page.dart';

class DashState {
  final PageController pageController;
  final int pageIndex;
  DashState({
    required this.pageController,
    required this.pageIndex,
  });
  final List<Widget> pages = [
    const GalleryPage(),
    const ArtistPage(),
  ];

  DashState copyWith({
    PageController? pageController,
    int? pageIndex,
  }) {
    return DashState(
      pageController: pageController ?? this.pageController,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }

  @override
  String toString() =>
      'DashState(pageController: $pageController, pageIndex: $pageIndex)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashState &&
        other.pageController == pageController &&
        other.pageIndex == pageIndex;
  }

  @override
  int get hashCode => pageController.hashCode ^ pageIndex.hashCode;
}
