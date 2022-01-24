import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kala/config/colors/basic_colors.dart';

// ignore: must_be_immutable
class ContentImage extends StatelessWidget {
  ContentImage({
    required this.image,
    Key? key,
  }) : super(key: key) {
    loadImageProvider();
  }

  final dynamic image;
  ImageProvider? imageProvider;

  void loadImageProvider() {
    if (image is String) {
      if (image.toString().isEmpty) {
        imageProvider = null;
      } else {
        imageProvider = CachedNetworkImageProvider(
          image.toString(),
          cacheKey: image.toString(),
          cacheManager: DefaultCacheManager(),
        );
      }
    } else if (image is File) {
      imageProvider = FileImage(image as File);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageProvider != null) {
      precacheImage(imageProvider!, context);
    }
    return Card(
      color: BasicColors.backgroundOffWhite,
      key: UniqueKey(),
      elevation: 20,
      child: imageProvider == null
          ? const CircularProgressIndicator()
          : Image(
              image: imageProvider!,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
    );
  }
}
