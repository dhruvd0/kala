import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

        final cellCount = (1.sw / 300).round();
        return SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: cellCount,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            children: state.contentSlideList
                .map(
                  (content) => StaggeredGridTile.fit(
                    crossAxisCellCount: 1,
                    child: ContentBlocProvider(content: content),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
