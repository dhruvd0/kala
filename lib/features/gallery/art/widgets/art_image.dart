import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/colors/basic_colors.dart';
import 'package:kala/features/gallery/art/bloc/art_bloc.dart';
import 'package:kala/common/models/art.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

// ignore: must_be_immutable
class ArtImage extends StatelessWidget {
  const ArtImage({
    Key? key,
    required this.image,
    this.overrideFit,
  }) : super(key: key);
  final BoxFit? overrideFit;
  final dynamic image;

  double imageElevation(BuildContext context) {
    try {
      return BlocProvider.of<ArtBloc>(context).state.viewMode ==
              ArtViewMode.grid
          ? 0
          : 10;
      // ignore: avoid_catching_errors
    } on AssertionError {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      constraints: BoxConstraints(
        minHeight: 100.h,
        maxHeight: (1.sh - 100) / 2,
      ),
      child: image == null
          ? const SizedBox()
          : Material(
              color: BasicColors.backgroundOffWhite,
              elevation: imageElevation(context),
              child: Image(
                image: image is String
                    ? OptimizedCacheImageProvider(
                        image,
                        cacheKey: image.toString(),
                      )
                    : FileImage(image as File) as ImageProvider,
                fit: overrideFit ?? BoxFit.fill,
              ),
            ),
    );
  }
}
