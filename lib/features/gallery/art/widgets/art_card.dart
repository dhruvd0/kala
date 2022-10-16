import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kala/common/models/art.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/config/size/size.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/features/artist_profile/services/artist_content_service.dart';
import 'package:kala/features/artist_profile/upload_art/bloc/upload_art_bloc.dart';
import 'package:kala/features/gallery/art/bloc/art_bloc.dart';
import 'package:kala/features/gallery/art/widgets/art_image.dart';
import 'package:kala/features/gallery/art/widgets/empty_art.dart';
import 'package:kala/features/gallery/art/widgets/keys.dart';

class ArtCard extends StatelessWidget {
  const ArtCard({Key? key, required this.art}) : super(key: key);
  final Art art;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadArtBloc(
        ArtistContentService(firebaseConfig.auth.currentUser!.uid),
      ),
      child: GestureDetector(
        onTap: () {
          if (art.isValid()) {
            Navigator.pushNamed(
              context,
              Routes.artPage,
              arguments: ArtBloc(art),
            );
          }
        },
        child: Container(
          constraints: !SizeUtils.isMobileSize()
              ? null
              : BoxConstraints(
                  maxHeight: art.viewMode == ArtViewMode.grid
                      ? gridElementSize()
                      : double.infinity,
                ),
          margin: art.viewMode == ArtViewMode.grid
              ? null
              : EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 40.h,
                ),
          child: !art.isValid()
              ? art.viewMode == ArtViewMode.scroll
                  ? Container()
                  : const EmptyArtCard()
              : Container(
                  constraints: BoxConstraints(maxWidth: 1.sw / 3),
                  key: ValueKey(
                    ArtCardKey.key(art.viewMode, art.docID),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (art.viewMode == ArtViewMode.grid)
                        Flexible(
                          child: ClipRect(
                            child: OverflowBox(
                              maxWidth: double.infinity,
                              maxHeight: double.infinity,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: ArtImage(
                                  image: art.imageFile ?? art.imageUrl,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        ArtImage(
                          image: art.imageFile ?? art.imageUrl,
                        ),
                      if (art.viewMode == ArtViewMode.grid)
                        const SizedBox()
                      else
                        SizedBox(
                          height: 20.h,
                        ),
                      if (art.viewMode == ArtViewMode.grid)
                        const SizedBox()
                      else
                        ArtBottomRow(
                          art: art,
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

class ArtBottomRow extends StatelessWidget {
  const ArtBottomRow({Key? key, required this.art}) : super(key: key);
  final Art art;
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
          ArtDescription(
            art: art,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                art.title,
                style: TextThemeContext(context).caption,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'by ${art.artistName}',
                style: TextThemeContext(context).subtitle1,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ArtDescription extends StatelessWidget {
  const ArtDescription({
    Key? key,
    required this.art,
  }) : super(key: key);
  final Art art;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !SizeUtils.isMobileSize() ? 1.sw / 10 : 1.sw / 2.5,
      child: AutoSizeText(
        '${art.description}\n\n '
        // ignore: lines_longer_than_80_chars
        '${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format((art.uploadTimestamp ?? Timestamp.now()).toDate())}',
        minFontSize: 8,
        style: TextThemeContext(context).bodyText2,
      ),
    );
  }
}
