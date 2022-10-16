import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/features/artist_profile/cubit/artist_content/artist_content_cubit.dart';
import 'package:kala/features/gallery/art/widgets/art_card.dart';

class GalleryGridView extends StatelessWidget {
  const GalleryGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistContentCubit, ArtistContentState>(
      bloc: getIt.get(),
      builder: (context, state) {
        if (state is ArtistContentLoadingState) {
          return const CircularProgressIndicator();
        }
        if (state is ArtistContentInitial) {
          return Container();
        }
        final userArt = (state as ArtistContentLoadedState).userArt;
        if (userArt.isEmpty) {
          return Container();
        }

        const cellCount = 3;

        return StaggeredGrid.count(
          crossAxisCount: cellCount,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          children: userArt
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
