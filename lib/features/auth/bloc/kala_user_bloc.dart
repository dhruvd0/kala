import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/features/auth/bloc/kala_user_state.dart';
import 'package:kala/features/auth/models/kala_user.dart';
import 'package:kala/features/auth/repositories/social_integration/social_integration.dart';
import 'package:kala/features/auth/repositories/user_collection.dart';
import 'package:kala/services/firebase/firebase_error.dart';

export 'kala_user_state.dart';

KalaUserBloc get kalaUserBloc => getIt.get<KalaUserBloc>();

class KalaUserBloc extends Cubit<KalaUserState> {
  KalaUserBloc({
    required this.socialSignIn,
    required this.userCollectionRepository,
  }) : super(InitialKalaUserState());
  final SocialSignIn socialSignIn;
  final UserCollectionRepository userCollectionRepository;
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  Future<void> registerKalaUser() async {
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

  Future<void> getKalaUser() async {
    final either = await userCollectionRepository
        .getKalaUser(firebaseConfig.auth.currentUser!.uid);
    await either.fold(
      (error) async {
        if (error is DocumentNotFound) {
          await registerKalaUser();
          return;
        }
        emit(KalaUserErrorState(error.message));
      },
      (kalaUser) async {
        emit(FetchedKalaUserState(kalaUser));
      },
    );
  }

  Future<void> authenticateWithSocialAuth(AuthTypes authType) async {
    emit(KalaUserLoadingState());
    final either = await socialSignIn.signInWithGoogle();

    await either.fold(
      (l) async => KalaUserErrorState(l.message!),
      (user) async {
        emit(AuthenticatedKalaUserState(user.uid));
        await getKalaUser();
      },
    );
  }

  void changeBio(String str) {
    // TODO(dhruv): change bio
  }

  void toggleEditMode({bool forceToggle = false}) {}

  void changeCover(File value) {}
}
