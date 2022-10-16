// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/features/artist_profile/cubit/artist_content/artist_content_cubit.dart';
import 'package:kala/features/artist_profile/cubit/artist_profile/kala_user_bloc.dart';
import 'package:kala/features/gallery/bloc/gallery_slide_bloc.dart';

class RoutinesWidget extends StatelessWidget {
  const RoutinesWidget({super.key});
  Future<void> postAuthenticationRoutine(BuildContext context) async {
    unawaited(getIt.get<GalleryBloc>().getArtList());
    getIt
      ..registerSingleton<ArtistContentCubit>(
        AuthenticatedArtistContentCubit(),
      )
      ..registerSingleton<AuthenticatedProfileBloc>(
        AuthenticatedProfileBloc(getIt.get()),
      );
    await Future.wait([
      getIt.get<AuthenticatedArtistContentCubit>().getArtistArt(),
      getIt.get<AuthenticatedProfileBloc>().syncUserProfile(),
    ]);
    await Navigator.pushReplacementNamed(context, Routes.dashboard);
  }

  Future<void> startupRoutine(BuildContext context) async {
    await Navigator.pushReplacementNamed(context, Routes.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
