import 'package:flutter/material.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/features/artist_profile/cubit/artist_profile/bloc_builder.dart';

class ArtistNameContainer extends StatelessWidget {
  const ArtistNameContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileBlocBuilder(
      loading: const CircularProgressIndicator(),
      fetched: (state) {
        return Text(
          state.kalaUser.name,
          style: TextThemeContext(context).headline1,
        );
      },
      error: (state) {
        return Text(state.message);
      },
    );
  }
}
