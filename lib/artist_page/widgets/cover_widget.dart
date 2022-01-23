import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_state.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/config/remote_config_data.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/main.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

class CoverContent extends StatelessWidget {
  const CoverContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserBloc, KalaUserState>(
      builder: (context, userState) {
        return Container(
          width: 1.sw,
          constraints: BoxConstraints(
            maxHeight: 182.h,
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            
          ),
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          child: userState.isEditMode ? AddCoverContent() : CoverImage(),
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
        return state.coverContent is File
            ? Image.file(
                state.coverContent,
                fit: BoxFit.fitWidth,
              )
            : GestureDetector(
                onTap: () {
                  final bloc = BlocProvider.of<KalaUserContentBloc>(
                    context,
                    listen: false,
                  );
                  bloc.scanImage(context).then((value) {
                    if (value is File) {
                      bloc.changeCover(value);
                    }
                  });
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FluentSystemIcons.ic_fluent_slide_add_regular),
                      SizedBox(
                        height: 16.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 47.w, right: 37.w),
                        child: AutoSizeText(
                          firebaseConfig?.remoteConfig.getString(
                                  RemoteConfigKeys.addNewContentPlaceholder) ??
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

class CoverImage extends StatelessWidget {
  const CoverImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
