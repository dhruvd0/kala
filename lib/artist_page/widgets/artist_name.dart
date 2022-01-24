import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/models/kala_user.dart';

import 'package:kala/config/theme/theme.dart';

class ArtistNameContainer extends StatelessWidget {
  const ArtistNameContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserBloc, KalaUser>(
      builder: (context, state) {
        return Text(
          state.name,
          style: TextThemeContext(context).headline1,
        );
      },
    );
  }
}
