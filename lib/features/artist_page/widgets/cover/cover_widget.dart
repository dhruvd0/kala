import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/remote_config_data.dart';
import 'package:kala/config/theme/theme.dart';

import 'package:kala/features/auth/bloc/kala_user_bloc.dart';
import 'package:kala/features/gallery/art/widgets/art_image.dart';
import 'package:kala/services/io/scan_image.dart';

class CoverArt extends StatelessWidget {
  const CoverArt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserBloc, KalaUserState>(
      builder: (context, userState) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: !userState.fetchedKalaUser.kalaUser.isEditMode &&
                        (userState.fetchedKalaUser.kalaUser.coverArt is File) ||
                    userState.fetchedKalaUser.kalaUser.isArtImageUrlValid()
                ? null
                : Border.all(),
            color: Colors.transparent,
          ),
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          child: userState.fetchedKalaUser.kalaUser.isEditMode
              ? const AddCoverArt()
              : ArtImage(image: userState.fetchedKalaUser.kalaUser.coverArt),
        );
      },
    );
  }
}

class AddCoverArt extends StatelessWidget {
  const AddCoverArt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserBloc, KalaUserState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            final bloc = BlocProvider.of<KalaUserBloc>(
              context,
            );
            scanImage(context).then((value) {
              if (value is File) {
                bloc
                  ..changeCover(value)
                  ..toggleEditMode();
              }
            });
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FluentSystemIcons.ic_fluent_slide_add_regular),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 47.w, right: 37.w),
                  child: AutoSizeText(
                    firebaseConfig.remoteConfig.getString(
                      RemoteConfigKeys.addNewArtPlaceholder,
                    ),
                    style: TextThemeContext(context).bodyText2,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
