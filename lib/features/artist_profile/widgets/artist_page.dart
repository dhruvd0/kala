import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kala/common/utils/widgets/offwhite_scaffold.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/features/artist_profile/cubit/artist_profile/kala_user_bloc.dart';
import 'package:kala/features/artist_profile/widgets/bio.dart';
import 'package:kala/features/artist_profile/widgets/cover/cover_widget.dart';
import 'package:kala/features/auth/bloc/auth_bloc.dart';
import 'package:kala/features/auth/bloc/auth_state.dart';
import 'package:kala/features/gallery/widgets/gallery_view/gallery_grid.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage({
    Key? key,
    required this.artistID,
  }) : super(
          key: key,
        );
  final String artistID;
  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      leading: GestureDetector(
        child: const Icon(Icons.logout),
        onTap: () {
          firebaseConfig.auth.signOut().then(
                (value) =>
                    Navigator.pushReplacementNamed(context, Routes.splash),
              );
        },
      ),
      trailing: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthenticatedState) {
            return Container();
          }
          return InkWell(
            onTap: () {
              getIt.get<AuthenticatedProfileBloc>().toggleEditMode();
            },
            child: BlocBuilder<AuthenticatedProfileBloc, KalaUserState>(
              builder: (context, state) {
                return Container(
                  margin: EdgeInsets.only(bottom: 5.h),
                  child: Icon(
                    state.fetchedKalaUser.kalaUser.isEditMode
                        ? EvaIcons.eye
                        : FontAwesomeIcons.penToSquare,
                    color: Colors.black,
                  ),
                );
              },
            ),
          );
        },
      ),
      scaffoldKey: const ValueKey(ScaffoldKeys.artistPageKey),
      enablePageNavigationArrows: true,
      centerTitle: kalaUserBloc.state is FetchedKalaUserState
          ? kalaUserBloc.state.fetchedKalaUser.kalaUser.name
          : '',
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
