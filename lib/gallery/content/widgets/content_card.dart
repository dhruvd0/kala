import 'dart:math' hide log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/size/size.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/gallery/content/widgets/content_image.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentBloc, Content>(
      builder: (context, state) {
        return Container(
          constraints: !SizeUtils.isMobileSize()
              ? null
              : BoxConstraints(
                  maxHeight: state.validate()
                      ? state.viewMode == ContentViewMode.grid
                          ? 80.h
                          : max(state.imgHeight.h, 1.sh - 70)
                      : 100.h,
                ),
          margin: state.viewMode == ContentViewMode.grid
              ? EdgeInsets.only(left: 1.w)
              : EdgeInsets.symmetric(
                  horizontal: kIsWeb ? 0 : 40.w,
                  vertical: 20.h,
                ),
          decoration: BoxDecoration(
            
            border: state.validate() ? null : Border.all(),
          ),
          child: !state.validate()
              ? const Center(
                  child: Icon(Icons.add),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.viewMode == ContentViewMode.grid)
                      Expanded(
                        child: ContentImage(
                          image: state.imageUrl ?? state.imageFile,
                        ),
                      )
                    else
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ContentImage(
                          image: state.imageUrl ?? state.imageFile,
                        ),
                      ),
                    if (state.viewMode == ContentViewMode.grid)
                      const SizedBox()
                    else
                      SizedBox(
                        height: 20.h,
                      ),
                    if (state.viewMode == ContentViewMode.grid)
                      const SizedBox()
                    else
                      const ContentBottomRow()
                  ],
                ),
        );
      },
    );
  }
}

class ContentBottomRow extends StatelessWidget {
  const ContentBottomRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentBloc, Content>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: !SizeUtils.isMobileSize() ? 0 : 5.w,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: !SizeUtils.isMobileSize() ? 1.sw / 10 : 1.sw / 2.5,
                child: AutoSizeText(
                  state.description,
                  minFontSize: 8,
                  style: TextThemeContext(context).bodyText2,
                ),
              ),
              Column(
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
                    'by ${state.artistName}',
                    style: TextThemeContext(context).subtitle1,
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
