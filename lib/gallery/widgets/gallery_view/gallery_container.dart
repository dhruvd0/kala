import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/figma/consts.dart';
import 'package:kala/config/size/size.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_grid.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_scroll.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        margin: EdgeInsets.only(top: 30.h, left: 10.w, right: 10.w),
        child: SizeUtils.isMobileSize()
            ? Center(child: GalleryScroll())
            : Center(child: GalleryGridView()),
      );
    });
  }
}
