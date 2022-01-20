import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

class ContentImage extends StatefulWidget {
  const ContentImage({
    required this.image,
    Key? key,
  }) : super(key: key);

  final dynamic image;

  @override
  State<ContentImage> createState() => _ContentImageState();
}

class _ContentImageState extends State<ContentImage> {
  ImageProvider? cachedNetworkImageProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.image is String) {
      cachedNetworkImageProvider = CachedNetworkImageProvider(widget.image.toString());
    } else if (widget.image is File){
      cachedNetworkImageProvider = FileImage(widget.image as File) ;

      precacheImage(cachedNetworkImageProvider!, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: UniqueKey(),
      elevation: 20,
      child: cachedNetworkImageProvider == null
          ? CircularProgressIndicator()
          : Image(
              image: cachedNetworkImageProvider!,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
    );
  }
}
