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
  const ContentImage({
    required this.image,
    this.overrideFit,
  });
  final BoxFit? overrideFit;
  final dynamic image;
  @override
  State<ContentImage> createState() => _ContentImageState();
}

class _ContentImageState extends State<ContentImage> {
  ImageProvider? imageProvider;

  void loadImageProvider() {
    if (widget.image is String) {
      if (widget.image.toString().isEmpty) {
        imageProvider = null;
      } else {
        try {
          imageProvider = CachedNetworkImageProvider(
            widget.image.toString(),
            cacheKey: widget.image.toString(),
            cacheManager: DefaultCacheManager(),
            errorListener: () {
              imageProvider = null;
            },
          );
        } on HttpException {
          imageProvider = null;
        }
      }
    } else if (widget.image is File) {
      imageProvider = FileImage(widget.image as File);
    }
  }

  @override
  void initState() {
    loadImageProvider();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (imageProvider != null) {
      try {
        precacheImage(
          imageProvider!,
          context,
        );
      } on HttpException {
        // url error
      }
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
          : 10;
      // ignore: avoid_catching_errors
    } on AssertionError {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageProvider == null
        ? Container()
        : Container(
            width: 1.sw,
            constraints: BoxConstraints(
              minHeight: 100.h,
              maxHeight: (1.sh - 100) / 2,
            ),
            child: Material(
              color: BasicColors.backgroundOffWhite,
              elevation: imageElevation(context),
              child: Image(
                image: imageProvider!,
                fit: widget.overrideFit ?? BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Container();
                },
                filterQuality: FilterQuality.high,
              ),
            ),
          );
  }
}
