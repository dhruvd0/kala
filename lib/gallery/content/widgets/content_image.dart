import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ContentImage extends StatefulWidget {
  const ContentImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);
  final String imageUrl;

  @override
  State<ContentImage> createState() => _ContentImageState();
}

class _ContentImageState extends State<ContentImage> {
  ImageProvider? cachedNetworkImageProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kIsWeb) {
      cachedNetworkImageProvider = NetworkImage(widget.imageUrl);
    } else {
      cachedNetworkImageProvider = CachedNetworkImageProvider(widget.imageUrl);

      precacheImage(cachedNetworkImageProvider!, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: UniqueKey(),
      elevation: 20,
      child: cachedNetworkImageProvider == null
          ? Container()
          : Image(
              image: cachedNetworkImageProvider!,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
    );
  }
}
