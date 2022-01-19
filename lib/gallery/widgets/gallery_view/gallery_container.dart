import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kala/config/size/size.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_grid.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_scroll.dart';

class GalleryContainer extends StatelessWidget {
  const GalleryContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizeUtils.isMobileSize()
          ? const GalleryScroll()
          : Center(
              child: GalleryGridView(),
            ),
    );
  }
}
