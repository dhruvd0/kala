import 'package:flutter/material.dart';
import 'package:kala/common/utils/widgets/offwhite_scaffold.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/features/gallery/widgets/gallery_view/gallery_layout.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return OffWhiteScaffold(
      scaffoldKey: const ValueKey(ScaffoldKeys.galleryPageKey),
      enablePageNavigationArrows: true,
      centerTitle: 'Kala Gallery',
      body: const GalleryLayout(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
