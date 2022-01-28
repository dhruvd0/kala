import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/artist_page/widgets/bio.dart';
import 'package:kala/artist_page/widgets/cover/cover_widget.dart';
import 'package:kala/artist_page/widgets/keys/artist_page/artist_page_keys.dart';
import 'package:kala/artist_page/widgets/keys/artist_page/gallery_grid.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';

import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/dashboard/widgets/dashboard_child_page.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';
import 'package:preload_page_view/preload_page_view.dart';

class ArtistPage extends DashBoardPage {
  const ArtistPage({required PreloadPageController controller, this.userID})
      : super(controller: controller);

  final String? userID;

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      trailing: Container(
        margin: EdgeInsets.only(right: 10.w),
        child: GestureDetector(
          onTap: () {
            BlocProvider.of<KalaUserContentBloc>(context, listen: false)
                .toggleEditMode();
          },
          child: const Icon(
            Icons.edit,
            key: ValueKey(ArtistPageKeys.toggleEditModeBtn),
            color: Colors.black,
          ),
        ),
      ),
      scaffoldKey: const ValueKey(ScaffoldKeys.artistPageKey),
      enablePageNavigationArrows: true,
      controller: controller,
      centerTitle:
          BlocProvider.of<KalaUserBloc>(context, listen: false).state.name,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40.h,
            ),
            const Flexible(child: CoverContent()),
            SizedBox(
              height: 40.h,
            ),
            const BioWidget(),
            SizedBox(
              height: 50.h,
            ),
            GalleryGridView()
          ],
        ),
      ),
    );
  }
}
