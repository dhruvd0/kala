import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/widgets/content_card.dart';

import 'package:kala/utils/widgets/text/animated_text.dart';

class Gallery extends StatelessWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryBloc, GalleryState>(
     
      builder: (context, state) {
        if (state.contentSlideList.isEmpty) {
        
          return Container();
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.contentSlideList.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            return BlocProvider(
              create: (context) => ContentBloc(state.contentSlideList[index]),
              child: const ContentCard(),
            );
          },
        );
      },
    );
  }
}
