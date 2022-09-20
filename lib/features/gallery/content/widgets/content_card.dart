import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kala/artist_page/add_new_content/bloc/add_new_content_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/config/size/size.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/gallery/content/widgets/content_image.dart';
import 'package:kala/gallery/content/widgets/empty_content.dart';
import 'package:kala/gallery/content/widgets/keys.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({Key? key, required this.content}) : super(key: key);
  final Content content;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddNewContentCubit(
        kalaUserContent: context.read<KalaUserContentBloc>(),
      ),
      child: GestureDetector(
        onTap: () {
          if (content.isValid()) {
            Navigator.pushNamed(
              context,
              Routes.contentPage,
              arguments: ContentBloc(content),
            );
          }
        },
        child: Container(
          constraints: !SizeUtils.isMobileSize()
              ? null
              : BoxConstraints(
                  maxHeight: content.viewMode == ContentViewMode.grid
                      ? gridElementSize()
                      : double.infinity,
                ),
          margin: content.viewMode == ContentViewMode.grid
              ? null
              : EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 40.h,
                ),
          child: !content.isValid()
              ? content.viewMode == ContentViewMode.scroll
                  ? Container()
                  : const EmptyContentCard()
              : Container(
                  constraints: BoxConstraints(maxWidth: 1.sw / 3),
                  key: ValueKey(
                    ContentCardKey.key(content.viewMode, content.docID),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (content.viewMode == ContentViewMode.grid)
                        Flexible(
                          child: ClipRect(
                            child: OverflowBox(
                              maxWidth: double.infinity,
                              maxHeight: double.infinity,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: ContentImage(
                                  image: content.imageFile ?? content.imageUrl,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        ContentImage(
                          image: content.imageFile ?? content.imageUrl,
                        ),
                      if (content.viewMode == ContentViewMode.grid)
                        const SizedBox()
                      else
                        SizedBox(
                          height: 20.h,
                        ),
                      if (content.viewMode == ContentViewMode.grid)
                        const SizedBox()
                      else
                        ContentBottomRow(
                          content: content,
                        )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  double gridElementSize() => (1.sw - 40.w) / 3;
}

class ContentBottomRow extends StatelessWidget {
  const ContentBottomRow({Key? key, required this.content}) : super(key: key);
  final Content content;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: !SizeUtils.isMobileSize() ? 0 : 15.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ContentDescription(
            content: content,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                content.title,
                style: TextThemeContext(context).caption,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'by ${content.artistName}',
                style: TextThemeContext(context).subtitle1,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ContentDescription extends StatelessWidget {
  const ContentDescription({
    Key? key,
    required this.content,
  }) : super(key: key);
  final Content content;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !SizeUtils.isMobileSize() ? 1.sw / 10 : 1.sw / 2.5,
      child: AutoSizeText(
        '${content.description}\n\n '
        // ignore: lines_longer_than_80_chars
        '${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format((content.uploadTimestamp ?? Timestamp.now()).toDate())}',
        minFontSize: 8,
        style: TextThemeContext(context).bodyText2,
      ),
    );
  }
}
