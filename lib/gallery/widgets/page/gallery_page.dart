import 'package:flutter/material.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/gallery/widgets/slide/gallery_slide.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  OffWhiteScaffold(
      key: const Key(Routes.gallery),
      centerTitle: "K",
      body: const Center(
        child: GallerySlide(),
      ),
    );
  }
}
