import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/widgets/content_card.dart';

class GallerySlide extends StatelessWidget {
  const GallerySlide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<GallerySlideBloc, GallerySlideState>(
        builder: (context, state) {
          return PageView(
            children: state.contentSlideList
                .map((content) => BlocProvider(
                      create: (context) => ContentBloc(content),
                      child: ContentCard(),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
