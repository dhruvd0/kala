import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_state.dart';

import 'package:kala/config/remote_config_data.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/gallery/content/widgets/content_image.dart';
import 'package:kala/main.dart';

class CoverContent extends StatelessWidget {
  const CoverContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserContentBloc, KalaUserContentState>(
    
      builder: (context, userState) {
        return Container(
         
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: !userState.isEditMode && (userState.coverContent is File) ||
                    userState.isContentImageUrlValid()
                ? null
                : Border.all(),
            color: Colors.transparent,
          ),
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          child: userState.isEditMode
              ? const AddCoverContent()
              : ContentImage(image: userState.coverContent),
        );
      },
    );
  }
}

class AddCoverContent extends StatelessWidget {
  const AddCoverContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserContentBloc, KalaUserContentState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            final bloc = BlocProvider.of<KalaUserContentBloc>(
              context,
              listen: false,
            );
            bloc.scanImage(context).then((value) {
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
                    firebaseConfig?.remoteConfig.getString(
                          RemoteConfigKeys.addNewContentPlaceholder,
                        ) ??
                        '',
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
