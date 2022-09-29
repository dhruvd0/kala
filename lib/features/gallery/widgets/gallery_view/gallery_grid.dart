import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kala/features/artist_page/cubit/artist_page_cubit.dart';
import 'package:kala/features/gallery/art/widgets/art_card.dart';

class GalleryGridView extends StatelessWidget {
  const GalleryGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistPageCubit, ArtistPageState>(
      builder: (context, state) {
        if (state.userArt.isEmpty) {
          return Container();
        }

        const cellCount = 3;

        return StaggeredGrid.count(
          crossAxisCount: cellCount,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          children: state.userArt
              .map(
                (e) => StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: ArtCard(
                    art: e,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
