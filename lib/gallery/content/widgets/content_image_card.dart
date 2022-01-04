
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentImageCard extends StatelessWidget {
  const ContentImageCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentBloc, Content>(
      builder: (context, state) {
        return InteractiveViewer(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: CachedNetworkImage(
              imageUrl: state.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
