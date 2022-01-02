import 'package:flutter/material.dart';
import 'package:kala/gallery/widgets/slide/gallery_slide.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OffWhiteScaffold(
      centerTitle: "Gallery",
        body: Center(
      child: GallerySlide(),
    ));
  }
}
