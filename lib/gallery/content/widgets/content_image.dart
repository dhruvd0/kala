import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/colors/basic_colors.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';

// ignore: must_be_immutable
class ContentImage extends StatefulWidget {
  ContentImage({
    required this.image,
    Key? key,
  }) : super(key: key) {
    loadImageProvider();
  }

  final dynamic image;
  ImageProvider? imageProvider;

  @override
  State<ContentImage> createState() => _ContentImageState();

  void loadImageProvider() {
    if (image is String) {
      if (image.toString().isEmpty) {
        imageProvider = null;
      } else {
        try {
          imageProvider = CachedNetworkImageProvider(image.toString(),
              cacheKey: image.toString(),
              cacheManager: DefaultCacheManager(), errorListener: () {
            imageProvider = null;
          });
        } on HttpException {
          imageProvider = null;
        }
      }
    } else if (image is File) {
      imageProvider = FileImage(image as File);
    }
  }
}

class _ContentImageState extends State<ContentImage> {
  @override
  void didChangeDependencies() {
    if (widget.imageProvider != null) {
      try {
        precacheImage(
          widget.imageProvider!,
          context,
        );
      } on HttpException {}
    }

    super.didChangeDependencies();
  }

  double imageElevation(BuildContext context) {
    try {
      return BlocProvider.of<ContentBloc>(context, listen: false)
                  .state
                  .viewMode ==
              ContentViewMode.grid
          ? 0
          : 20;
      // ignore: avoid_catching_errors
    } on AssertionError {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.imageProvider == null
        ? Container()
        : Container(
            width: 1.sw,
            constraints: BoxConstraints(
              minHeight: 100.h,
              maxHeight: (1.sh - 100) / 2,
            ),
            child: Card(
              color: BasicColors.backgroundOffWhite,
              key: UniqueKey(),
              elevation: imageElevation(context),
              child: Image(
                image: widget.imageProvider!,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Container();
                },
                filterQuality: FilterQuality.high,
              ),
            ),
          );
  }
}
