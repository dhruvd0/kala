import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_state.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_scroll.dart';

class GalleryGridView extends StatelessWidget {
  const GalleryGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserContentBloc, KalaUserContentState>(
      builder: (context, state) {
        if (state.userContent == null) {
          return Container();
        }
        if (state.userContent?.isEmpty ?? false) {
          return Container();
        }

        const cellCount = 3;

        return StaggeredGrid.count(
          crossAxisCount: cellCount,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          children: state.userContent!
              .map(
                (e) => StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: ContentBlocProvider(
                    content: e,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
