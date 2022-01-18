import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/figma/consts.dart';
import 'package:kala/config/size/size.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_grid.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_scroll.dart';

class GalleryContainer extends StatefulWidget {
  const GalleryContainer({Key? key}) : super(key: key);

  @override
  State<GalleryContainer> createState() => _GalleryContainerState();
}

class _GalleryContainerState extends State<GalleryContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizeUtils.isMobileSize()
          ? GalleryScroll()
          : Center(
              child: GalleryGridView(),
            ),
    );
  }
}
