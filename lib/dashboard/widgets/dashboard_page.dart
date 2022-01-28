import 'package:flutter/material.dart';
import 'package:kala/acquires_page/widgets/acquires_page.dart';
import 'package:kala/artist_page/widgets/artist_page.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';

import 'package:kala/gallery/widgets/page/gallery_page.dart';
import 'package:preload_page_view/preload_page_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  PreloadPageController pageController = PreloadPageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      child: PreloadPageView(
        key: const ValueKey(ScaffoldKeys.dashboard),
        physics: const BouncingScrollPhysics(),
        controller: pageController,
        preloadPagesCount: 2,
        children: [
          GalleryPage(pageController),
          ArtistPage(
            controller: pageController,
          ),
          AcquiresPage(
            pageController: pageController,
          )
        ],
      ),
    );
  }
}
