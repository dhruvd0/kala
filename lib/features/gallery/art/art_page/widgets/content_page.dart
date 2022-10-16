import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/common/models/art.dart';
import 'package:kala/common/utils/widgets/offwhite_scaffold.dart';
import 'package:kala/features/gallery/art/bloc/art_bloc.dart';
import 'package:kala/features/gallery/art/widgets/art_card.dart';
import 'package:kala/features/gallery/art/widgets/art_image.dart';

class ArtPage extends StatelessWidget {
  const ArtPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtBloc, Art>(
      builder: (context, art) {
        return OffWhiteScaffold(
          scaffoldKey: ValueKey('art-page-${art.docID}'),
          centerTitle: art.title,
          onBack: () {
            Navigator.pop(context);
          },
          enableBackArrow: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 13),
                child: ArtImage(image: art.imageFile ?? art.imageUrl),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: ArtDescription(
                  art: art,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
