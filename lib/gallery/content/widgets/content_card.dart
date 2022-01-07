import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/gallery/content/widgets/content_image.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentBloc, Content>(
      builder: (context, state) {
        return Center(
          key: Key("Content${state.contentID}"),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContentImage(
                  imageUrl: state.imageUrl,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 1.sw / 2 - 10),
                        child: AutoSizeText(
                          state.description,
                          style: TextThemeContext(context).bodyText2,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            state.title,
                            style: TextThemeContext(context).caption,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "by ${state.artistName}",
                            style: TextThemeContext(context).subtitle1,
                          )
                        ],
                      )
                    ],
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
