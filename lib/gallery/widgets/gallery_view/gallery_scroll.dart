import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/widgets/content_card.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

class GalleryScroll extends StatefulWidget {
  const GalleryScroll({
    Key? key,
  }) : super(key: key);

  @override
  State<GalleryScroll> createState() => _GalleryScrollState();
}

class _GalleryScrollState extends State<GalleryScroll> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        if (scrollController.hasClients) {
          if (scrollController.offset / 300 > 5) {
            context.read<GalleryBloc>().getContentList(
                  scrollController.offset.toInt(),
                  collectionSegment: CollectionSegment.next,
                );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryBloc, GalleryState>(
      builder: (context, state) {
        if (state.contentSlideList.isEmpty) {
          return Container();
        }

        return ListView.builder(
          cacheExtent: 9999,
          addSemanticIndexes: false,
          semanticChildCount: 0,
          controller: scrollController,
          itemCount: state.contentSlideList.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            return ContentCard(
              key: ValueKey(state.contentSlideList[index].docID),
              content: state.contentSlideList[index],
            );
          },
        );
      },
    );
  }
}
