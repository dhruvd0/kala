import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/features/artist_profile/cubit/artist_profile/kala_user_bloc.dart';

class ProfileBlocBuilder extends StatelessWidget {
  const ProfileBlocBuilder({
    Key? key,
    required this.loading,
    required this.fetched,
    required this.error,
  }) : super(key: key);
  final Widget loading;
  final Widget Function(FetchedKalaUserState) fetched;
  final Widget Function(KalaUserErrorState) error;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, KalaUserState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case KalaUserLoadingState:
            return loading;
          case KalaUserErrorState:
            return error(state as KalaUserErrorState);

          case FetchedKalaUserState:
            return fetched(state as FetchedKalaUserState);

          default:
            return loading;
        }
      },
    );
  }
}
