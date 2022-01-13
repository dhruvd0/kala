import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_scroll.dart';

class GalleryGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryBloc, GalleryState>(
      builder: (context, state) {
        if (state.contentSlideList.isEmpty) {
          return Container();
        }

        return GridView.count(
            primary: false,
            crossAxisCount: 4,
            children: state.contentSlideList
                .map((e) => ContentBlocProvider(content: e))
                .toList());
      },
    );
  }
}
