import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/features/auth/bloc/kala_user_state.dart';
import 'package:kala/features/auth/models/kala_user.dart';
import 'package:kala/features/auth/repositories/social_integration/social_integration.dart';
import 'package:kala/features/auth/repositories/user_collection.dart';

export 'kala_user_state.dart';

class KalaUserBloc extends Cubit<KalaUserState> {
  KalaUserBloc({
    required this.socialSignIn,
    required this.userCollectionRepository,
  }) : super(const InitialKalaUserState());
  final SocialSignIn socialSignIn;
  final UserCollectionRepository userCollectionRepository;
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  Future<void> registerKalaUser(KalaUser kalaUser) async {
    (await userCollectionRepository.createKalaUser(
      firebaseConfig.auth.currentUser!.uid,
      kalaUser.toMap(),
    ))
        .fold(
      (error) => KalaUserErrorState(error.message),
      (timeCreated) => log(timeCreated.toString()),
    );
  }

  Future<void> getKalaUser() async {
    (await userCollectionRepository
            .getKalaUser(firebaseConfig.auth.currentUser!.uid))
        .fold(
      (error) async {
        if (error.message == 'not registered') {
          await registerKalaUser(state.kalaUser);
          return;
        }
        emit(KalaUserErrorState(error.message));
      },
      (kalaUser) => emit(AuthenticatedKalaUserState(kalaUser: kalaUser)),
    );
  }

  Future<void> authenticateWithSocialAuth(AuthTypes authType) async {
    (await socialSignIn.signInWithGoogle()).fold(
      (l) => KalaUserErrorState(l.message!),
      (user) async {
        await getKalaUser();
      },
    );
  }

  void changeBio(String str) {
    ///TODO: change bio
  }



  void toggleEditMode({bool forceToggle = false}) {}

  changeCover(File value) {}
}
