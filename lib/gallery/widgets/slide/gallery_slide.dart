import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/widgets/content_image_page_view.dart';
import 'package:kala/utils/widgets/text/animated_text.dart';

class GallerySlide extends StatelessWidget {
  const GallerySlide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      child: BlocBuilder<GallerySlideBloc, GallerySlideState>(
        buildWhen: (prev, next) {
          if (prev.viewingIndex != next.viewingIndex) {
            return true;
          }
          if (prev.contentSlideList.length != next.contentSlideList.length) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state.contentSlideList.isEmpty) {
            return Container();
          }
          var viewingContent = state.contentSlideList[state.viewingIndex];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10.h,
              ),
              RotatingText(
                text: viewingContent.title,
                style: TextThemeContext(context).headline2,
              ),
              SizedBox(
                height: 20.h,
              ),
              const ContentImagePageView(),
              SizedBox(
                height: 15.h,
              ),
              Text(
                "by ${viewingContent.artistName}",
                style: TextThemeContext(context).headline3,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                viewingContent.description,
                textAlign: TextAlign.center,
                style: TextThemeContext(context).bodyText1,
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          );
        },
      ),
    );
  }
}
