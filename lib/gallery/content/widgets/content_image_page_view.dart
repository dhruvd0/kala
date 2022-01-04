// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/widgets/content_image_card.dart';
class ContentImagePageView extends StatelessWidget {
  const ContentImagePageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GallerySlideBloc, GallerySlideState>(
      builder: (context, state) {
        return SizedBox(
          height: 1.sw / 1.5,
          child: PageView(
            onPageChanged: (index) {
              BlocProvider.of<GallerySlideBloc>(context, listen: false)
                  .changeViewingIndex(index);
            },
            children: state.contentSlideList
                .map(
                  (content) => BlocProvider(
                    create: (context) => ContentBloc(content),
                    child: const ContentImageCard(),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
