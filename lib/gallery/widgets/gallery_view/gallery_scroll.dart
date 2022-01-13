import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/gallery/content/widgets/content_card.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_grid.dart';

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
            context.read<GalleryBloc>().getContentList();
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
          shrinkWrap: true,
          controller: scrollController,
          itemCount: state.contentSlideList.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            return ContentBlocProvider(content:state.contentSlideList[index]);
          },
        );
      },
    );
  }
}

class ContentBlocProvider extends StatelessWidget {
  const ContentBlocProvider({
    Key? key,
    required this.content
  }) : super(key: key);
  final Content content;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContentBloc(content),
      child: const ContentCard(),
    );
  }
}
