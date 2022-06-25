import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/gallery/content/bloc/content_bloc.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/gallery/content/widgets/content_card.dart';
import 'package:kala/gallery/content/widgets/content_image.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentBloc, Content>(
      builder: (context, content) {
        return OffWhiteScaffold(
          scaffoldKey: ValueKey('content-page-${content.docID}'),
          centerTitle: content.title,
          onBack: () {
            Navigator.pop(context);
          },
          enableBackArrow: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 13),
                child:
                    ContentImage(image: content.imageFile ?? content.imageUrl),
              ),
              const SizedBox(
                height: 10,
              ),
              const ContentDescription(),
            ],
          ),
        );
      },
    );
  }
}
