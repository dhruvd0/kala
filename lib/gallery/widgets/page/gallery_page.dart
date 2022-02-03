import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/dashboard/widgets/dashboard_child_page.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_container.dart';
import 'package:kala/main.dart';

import 'package:kala/utils/widgets/offwhite_scaffold.dart';
import 'package:preload_page_view/preload_page_view.dart';

class GalleryPage extends DashBoardPage {
  const GalleryPage(PreloadPageController controller)
      : super(controller: controller);

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      scaffoldKey: const ValueKey(ScaffoldKeys.galleryPageKey),
      enablePageNavigationArrows: true,
      centerTitle: 'Kala Gallery',
      controller: controller,
      trailing: GestureDetector(
        child: const Icon(Icons.logout),
        onTap: () {
          firebaseConfig?.auth.signOut().then(
                (value) =>
                    Navigator.pushReplacementNamed(context, Routes.dashboard),
              );
        },
      ),
      body: const GalleryContainer(),
    );
  }
}
