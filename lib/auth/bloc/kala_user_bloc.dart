import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/foundation.dart';
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
  KalaUserBloc() : super(unauthenticatedBaseUser()) {
    registerAuthListener();
  }

  void registerAuthListener() {
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
      } else {
        emit(unauthenticatedBaseUser());
      }
    });
  }

  static UnauthenticatedKalaUserState unauthenticatedBaseUser() {
    return UnauthenticatedKalaUserState(KalaUser(
      name: "",
      authType: "",
      photoURL: "",
      contactURL: "",
      lastSignIn: null,
    ));
  }

  @override
  void onChange(Change<KalaUserState> change) {
    super.onChange(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  void updateLastSignedInTimeStamp() async {
    var uid = firebaseConfig?.auth.currentUser?.uid;

    try {
      await firebaseConfig?.firestore
          .collection(FirestorePaths.userCollection)
          .doc(uid)
          .update({"lastSignIn": Timestamp.now()});
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
    }
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
        try {
          emit(ActiveKalaUserState(userFromSnapshot));
        } on StateError catch (e) {
          
        }
      });
    }
  }

  Future<void> authenticateWithSocialAuth(String authType) async {
    if (TEST_FLAG) {
      await mockAuthentication(authType);
      return;
    }

    switch (authType) {
      case AuthTypes.google:
        await signInWithGoogle();
        break;
    }
  }

  Future<void> mockAuthentication(String authType) async {
    KalaUser kalaUser;
    assert(firebaseConfig?.auth is MockFirebaseAuth);
    await firebaseConfig?.auth.signInAnonymously();
    assert(firebaseConfig?.auth.currentUser != null);
    kalaUser = KalaUser.fromSocialAuthUser(
      firebaseConfig?.auth.currentUser as User,
      authType: "mock-$authType",
    );
    kalaUser.validateUser();
    emit(AuthenticatedKalaUserState(kalaUser));
  }
}
