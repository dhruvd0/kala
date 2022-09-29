import 'package:flutter/material.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/features/auth/bloc/bloc_builder.dart';

class ArtistNameContainer extends StatelessWidget {
  const ArtistNameContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KalaUserBlocBuilder(
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
