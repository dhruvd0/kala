import 'package:flutter/material.dart';
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
      return SizedBox(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: constraints.maxWidth > 500
            ? GalleryGridView()
            : GalleryScroll(),
      );
    });
  }
}
