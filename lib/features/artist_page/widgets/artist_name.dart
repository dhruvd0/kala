import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/features/auth/bloc/kala_user_bloc.dart';
import 'package:kala/features/auth/models/kala_user.dart';

class ArtistNameContainer extends StatelessWidget {
  const ArtistNameContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserBloc, KalaUserState>(
      builder: (context, state) {
        return Text(
          state.kalaUser.name,
          style: TextThemeContext(context).headline1,
        );
      },
    );
  }
}
