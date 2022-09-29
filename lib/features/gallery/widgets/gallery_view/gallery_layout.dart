import 'package:flutter/material.dart';
import 'package:kala/config/size/size.dart';
import 'package:kala/features/gallery/widgets/gallery_view/gallery_grid.dart';
import 'package:kala/features/gallery/widgets/gallery_view/gallery_scroll.dart';

class GalleryLayout extends StatelessWidget {
  const GalleryLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizeUtils.isMobileSize()
          ? const GalleryScroll()
          : const Center(
              child: GalleryGridView(),
            ),
    );
  }
}
