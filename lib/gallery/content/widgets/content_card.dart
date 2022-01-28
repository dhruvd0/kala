import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kala/artist_page/add_new_content/bloc/add_new_content_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/config/size/size.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/gallery/content/widgets/content_image.dart';
import 'package:kala/gallery/content/widgets/empty_content.dart';
import 'package:kala/gallery/content/widgets/keys.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => AddNewContentCubit(
        kalaUserContent: context.read<KalaUserContentBloc>(),
      ),
      child: BlocBuilder<ContentBloc, Content>(
        key: UniqueKey(),
        builder: (context, state) {
          return Container(
            constraints: !SizeUtils.isMobileSize()
                ? null
                : BoxConstraints(
                    minHeight: (state.viewMode == ContentViewMode.scroll &&
                            state.imgWidth > 1)
                        ? 100.h
                        : 100.h,
                    maxHeight: state.viewMode == ContentViewMode.grid
                        ? gridElementSize()
                        : double.infinity,
                  ),
            margin: state.viewMode == ContentViewMode.grid
                ? null
                : EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 20.h,
                  ),
            child: !state.isValid()
                ? state.viewMode == ContentViewMode.scroll
                    ? Container()
                    : const EmptyContentCard()
                : Container(
                    constraints: BoxConstraints(maxWidth: 1.sw / 3),
                    key: ValueKey(
                      ContentCardKey.key(state.viewMode, state.docID),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state.viewMode == ContentViewMode.grid)
                          Flexible(
                            child: ClipRect(
                              child: OverflowBox(
                                maxWidth: double.infinity,
                                maxHeight: double.infinity,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: ContentImage(
                                    image: state.imageFile ?? state.imageUrl,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          ContentImage(
                            image: state.imageUrl ?? state.imageFile,
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
                  ),
          );
        },
      ),
    );
  }

  double gridElementSize() => (1.sw - 40.w) / 3;
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
            horizontal: !SizeUtils.isMobileSize() ? 0 : 15.w,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: !SizeUtils.isMobileSize() ? 1.sw / 10 : 1.sw / 2.5,
                child: AutoSizeText(
                  state.description.isEmpty
                      ? DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY)
                          .format(state.uploadTimestamp!.toDate())
                      : state.description,
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
