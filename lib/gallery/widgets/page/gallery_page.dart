import 'package:flutter/material.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_container.dart';

import 'package:kala/main.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      scaffoldKey: const ValueKey(ScaffoldKeys.galleryPageKey),
      enablePageNavigationArrows: true,
      centerTitle: "Kala Gallery",
      body: const GalleryContainer(),
    );
  }
}
