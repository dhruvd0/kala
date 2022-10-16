import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/common/models/art.dart';
import 'package:kala/common/services/io/scan_image.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/features/artist_profile/cubit/artist_profile/kala_user_bloc.dart';
import 'package:kala/features/artist_profile/upload_art/bloc/upload_art_bloc.dart';
import 'package:kala/features/artist_profile/upload_art/bloc/upload_art_state.dart';
import 'package:kala/features/artist_profile/upload_art/widgets/add_new_art_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EmptyArtCard extends StatelessWidget {
  const EmptyArtCard({
    Key? key,
  }) : super(key: key);
  double gridElementSize() => (1.sw - 40.w) / 3;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      constraints: BoxConstraints(
        minHeight: gridElementSize(),
        maxHeight: gridElementSize(),
      ),
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      child: BlocBuilder<UploadArtBloc, UploadArtState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              final bloc = BlocProvider.of<UploadArtBloc>(
                context,
              );
              scanImage(context).then(
                (file) {
                  if (file != null) {
                    bloc.editNewArt(ArtProps.image, file).then(
                          (value) => showCupertinoModalBottomSheet(
                            context: context,
                            expand: true,
                            isDismissible: true,
                            builder: (context) => BlocProvider.value(
                              value: bloc,
                              child: const AddNewArtSheet(),
                            ),
                          ).then((value) {
                            final isInEditMode =
                                (BlocProvider.of<AuthenticatedProfileBloc>(
                              context,
                            ).state as FetchedKalaUserState)
                                    .kalaUser
                                    .isEditMode;
                            if (!isInEditMode) {
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.dashboard,
                              );
                            }
                          }),
                        );
                  }
                },
              );
            },
            child: SizedBox(
              height: 70.h,
              child: const Center(
                child: Icon(FluentSystemIcons.ic_fluent_add_regular),
              ),
            ),
          );
        },
      ),
    );
  }
}
