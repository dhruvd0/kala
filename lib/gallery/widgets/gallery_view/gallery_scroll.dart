import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/gallery/content/widgets/content_card.dart';

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
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        if (scrollController.hasClients) {
          if (scrollController.offset / 300 > 5) {
            context.read<GalleryBloc>().getContentList(scrollController.offset.toInt());
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
          addSemanticIndexes: false,
          semanticChildCount: 0,
          controller: scrollController,
          itemCount: state.contentSlideList.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            return ContentBlocProvider(content: state.contentSlideList[index]);
          },
        );
      },
    );
  }
}

class ContentBlocProvider extends StatelessWidget {
  const ContentBlocProvider({
    required this.content,
    Key? key,
  }) : super(key: key);

  final Content content;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: UniqueKey(),
      create: (context) => ContentBloc(content),
      child: const ContentCard(),
    );
  }
}
