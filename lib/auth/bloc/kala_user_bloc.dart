import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/auth/social_integration/auth_types.dart';
import 'package:kala/auth/social_integration/google.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/main.dart';

class KalaUserBloc extends Cubit<KalaUserState> {
  StreamSubscription<User?>? authStream;
  KalaUserBloc()
      : super(
          UnauthenticatedKalaUserState(KalaUser(
            name: "",
            authType: "",
            photoURL: "",
            contactURL: "",
            lastSignIn: null,
          )),
        ) {
    authStream = firebaseConfig?.auth.authStateChanges().listen((user) {
      if (user != null && user.uid.isNotEmpty) {
        emit(
          AuthenticatedKalaUserState(
            KalaUser.fromSocialAuthUser(
              user,
            ),
          ),
        );
        startUserSnapshotFetcher();
      }
     
    });
  }
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  Future<void> updateKalaUserToFirestore() async {
    var uid = firebaseConfig?.auth.currentUser?.uid;

    if (firebaseConfig?.auth.currentUser == null) {
      Fluttertoast.showToast(msg: "Log in First");
    }

    try {
      await firebaseConfig?.firestore
          .collection(FirestorePaths.userCollection)
          .doc(uid)
          .update(state.toMap());
    } on FirebaseException {
      addKalaUserToFirestore();
    }
  }

  Future<void> addKalaUserToFirestore() async {
    var uid = firebaseConfig?.auth.currentUser?.uid;

    if (firebaseConfig?.auth.currentUser == null) {
      Fluttertoast.showToast(msg: "Log in First");
    }
    assert(state.kalaUser.validateUser());
    await firebaseConfig?.firestore
        .collection(FirestorePaths.userCollection)
        .doc(uid)
        .set(state.toMap());
  }

  void startUserSnapshotFetcher() async {
    var uid = firebaseConfig?.auth.currentUser?.uid;
    if (uid?.isNotEmpty ?? false) {
      firebaseConfig?.firestore
          .collection(FirestorePaths.userCollection)
          .doc(uid)
          .snapshots()
          .listen((event) async {
        if (event.data() == null) {
          await addKalaUserToFirestore();
          return;
        }
        KalaUser userFromSnapshot = KalaUser.fromMap(
          event.data()!,
        );

        assert(userFromSnapshot.validateUser());
        emit(ActiveKalaUserState(userFromSnapshot));
      });
    }
  }

  Future<void> authenticateWithSocialAuth(String authType) async {
    KalaUser? kalaUser;
    if (firebaseConfig?.auth is MockFirebaseAuth) {
      await firebaseConfig?.auth.signInAnonymously();
      assert(firebaseConfig?.auth.currentUser != null);
      kalaUser = KalaUser.fromSocialAuthUser(
        firebaseConfig?.auth.currentUser as User,
        authType: "mock-$authType",
      );
      emit(AuthenticatedKalaUserState(kalaUser));
      startUserSnapshotFetcher();
      return;
    }
    switch (authType) {
      case AuthTypes.google:
        kalaUser = await signInWithGoogle();
        break;
    }
    if (kalaUser != null) {
      emit(AuthenticatedKalaUserState(kalaUser));
    }
    startUserSnapshotFetcher();
  }
}
