import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentBloc, Content>(
      builder: (context, state) {
        return Container(
          width: 100,
          margin: const EdgeInsets.all(2),
          child: CachedNetworkImage(
            imageUrl: state.imageUrl,
          ),
        );
      },
    );
  }
}
