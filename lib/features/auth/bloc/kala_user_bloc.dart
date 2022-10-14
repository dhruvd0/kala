import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/common/models/kala_user.dart';
import 'package:kala/common/services/firebase/firebase_error.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/features/auth/bloc/kala_user_state.dart';
import 'package:kala/features/auth/repositories/social_integration/social_integration.dart';
import 'package:kala/features/auth/repositories/user_collection.dart';

export 'kala_user_state.dart';

ProfileBloc get kalaUserBloc => getIt.get<ProfileBloc>();

class ProfileBloc extends Cubit<KalaUserState> {
  ProfileBloc(this.userCollectionRepository)
      : super(
          InitialKalaUserState(),
        );
  final UserProfileRepository userCollectionRepository;

  Future<void> getKalaUser(User user) async {
    emit(KalaUserLoadingState());
    final either = await userCollectionRepository.getKalaUser(user.uid);
    await either.fold(
      (error) async {
        if (error is DocumentNotFound) {
          emit(UserNotFoundState());
          return;
        }
        emit(KalaUserErrorState(error.message));
      },
      (kalaUser) async {
        emit(FetchedKalaUserState(kalaUser));
      },
    );
  }
}

class AuthenticatedProfileBloc extends ProfileBloc {
  AuthenticatedProfileBloc(super.userCollectionRepository);
  Future<void> syncUserProfile() async {
    await getKalaUser(firebaseConfig.auth.currentUser!);
    if (state is UserNotFoundState) {
      await _registerKalaUser(firebaseConfig.auth.currentUser!);
    }
  }

  Future<void> _registerKalaUser(User user) async {
    emit(KalaUserLoadingState());
    (await userCollectionRepository.createKalaUser(
      firebaseConfig.auth.currentUser!,
      AuthTypes.google.name,
    ))
        .fold(
      (error) => emit(KalaUserErrorState(error.message)),
      (timeCreated) {
        log(timeCreated.toString());
        emit(
          FetchedKalaUserState(
            KalaUser.fromSocialAuthUser(firebaseConfig.auth.currentUser!),
          ),
        );
      },
    );
  }
}
