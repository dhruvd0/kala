import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/features/artist_page/widgets/bio.dart';
import 'package:kala/features/artist_page/widgets/cover/cover_widget.dart';
import 'package:kala/features/gallery/widgets/gallery_view/gallery_grid.dart';

import 'package:kala/features/auth/bloc/kala_user_bloc.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      leading: GestureDetector(
        child: const Icon(Icons.logout),
        onTap: () {
          firebaseConfig.auth.signOut().then(
                (value) =>
                    Navigator.pushReplacementNamed(context, Routes.dashboard),
              );
        },
      ),
      trailing: InkWell(
        onTap: () {
          BlocProvider.of<KalaUserBloc>(context).toggleEditMode();
        },
        child: BlocBuilder<KalaUserBloc, KalaUserState>(
          builder: (context, state) {
            return Container(
              margin: EdgeInsets.only(bottom: 5.h),
              child: Icon(
                state.kalaUser.isEditMode
                    ? EvaIcons.eye
                    : FontAwesomeIcons.penToSquare,
                color: Colors.black,
              ),
            );
          },
        ),
      ),
      scaffoldKey: const ValueKey(ScaffoldKeys.artistPageKey),
      enablePageNavigationArrows: true,
      centerTitle: BlocProvider.of<KalaUserBloc>(context).state.kalaUser.name,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40.h,
            ),
            const Flexible(child: CoverArt()),
            SizedBox(
              height: 40.h,
            ),
            const BioWidget(),
            SizedBox(
              height: 50.h,
            ),
            const GalleryGridView()
          ],
        ),
      ),
    );
  }
}
