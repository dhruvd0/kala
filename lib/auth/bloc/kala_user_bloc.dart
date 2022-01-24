import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/auth/social_integration/auth_types.dart';
import 'package:kala/auth/social_integration/google.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/main.dart';

class KalaUserBloc extends Cubit<KalaUser> {
  KalaUserBloc() : super(unauthenticatedBaseUser()) {
    registerAuthListener();
  }

  StreamSubscription<User?>? authStream;

  @override
  Future<void> close() {
    authStream?.cancel();
    return super.close();
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  void registerAuthListener() {
    authStream = firebaseConfig?.auth.authStateChanges().listen((user) {
      if (user != null && user.uid.isNotEmpty) {
        emit(
          KalaUser.fromSocialAuthUser(
            user,
          ),
        );
        startUserSnapshotFetcher();
      } else {
        emit(unauthenticatedBaseUser());
      }
    });
  }

  static KalaUser unauthenticatedBaseUser() {
    return const KalaUser(
      name: '',
      authType: '',
      photoURL: '',
      contactURL: '',
      lastSignIn: null,
      uid: '',
      userMapData: {},
      kalaUserState: KalaUserState.unauthenticated,
    );
  }

  Future<void> updateLastSignedInTimeStamp() async {
    final uid = firebaseConfig?.auth.currentUser?.uid;

    await firebaseConfig?.firestore
        .collection(FirestorePaths.userCollection)
        .doc(uid)
        .update({'lastSignIn': Timestamp.now()});
  }

  Future<void> updateKalaUserToFirestore() async {
    final uid = firebaseConfig?.auth.currentUser?.uid;

    if (firebaseConfig?.auth.currentUser == null) {
      await Fluttertoast.showToast(msg: 'Log in First');
    }

    try {
      await firebaseConfig?.firestore
          .collection(FirestorePaths.userCollection)
          .doc(uid)
          .update(state.toMap());
    } on FirebaseException {
      await addKalaUserToFirestore();
    }
  }

  Future<void> addKalaUserToFirestore() async {
    final uid = firebaseConfig?.auth.currentUser?.uid;

    if (firebaseConfig?.auth.currentUser == null) {
      await Fluttertoast.showToast(msg: 'Log in First');
    }
    assert(state.validateUser());
    await firebaseConfig?.firestore
        .collection(FirestorePaths.userCollection)
        .doc(uid)
        .set(state.toMap());
  }

  Future<void> startUserSnapshotFetcher() async {
    final uid = firebaseConfig?.auth.currentUser?.uid;
    if (uid?.isNotEmpty ?? false) {
      firebaseConfig?.firestore
          .collection(FirestorePaths.userCollection)
          .doc(uid)
          .snapshots()
          .listen((event) async {
        final data = event.data();
        if (data == null) {
          await addKalaUserToFirestore();

          return;
        }
        data['uid'] = firebaseConfig?.auth.currentUser?.uid;
        var userFromSnapshot = KalaUser.fromMap(
          data,
        );
        userFromSnapshot =
            userFromSnapshot.copyWith(kalaUserState: KalaUserState.active);

        assert(userFromSnapshot.validateUser());
        try {
          emit(userFromSnapshot);
        // ignore: avoid_catching_errors
        } on StateError {
          log('State Error');
          return;
        }
      });
    }
  }

  Future<void> authenticateWithSocialAuth(String authType) async {
    if (isTestMode) {
      await mockAuthentication(authType);
      return;
    }

    switch (authType) {
      case AuthTypes.google:
        await signInWithGoogle();
        break;
    }
    await Fluttertoast.showToast(msg: 'Signed In');
  }

  Future<void> mockAuthentication(String authType) async {
    KalaUser kalaUser;
    assert(firebaseConfig?.auth is MockFirebaseAuth);
    await firebaseConfig?.auth.signInAnonymously();
    assert(firebaseConfig?.auth.currentUser != null);
    if (firebaseConfig?.auth.currentUser != null) {
      kalaUser = KalaUser.fromSocialAuthUser(
        // ignore: cast_nullable_to_non_nullable
        firebaseConfig?.auth.currentUser as User,
        authType: 'mock-$authType',
      )..validateUser();

      emit(kalaUser);
    }
  }


  
}
