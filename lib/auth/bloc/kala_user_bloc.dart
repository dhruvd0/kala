import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/auth/social_integration/google.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/main.dart';

class KalaUserBloc extends Cubit<KalaUser> {
  KalaUserBloc()
      : super(
          KalaUser(
            name: "",
            id: "",
            authType: "",
            photoURL: "",
            contactURL: "",
          ),
        );
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  @override
  void onChange(Change<KalaUser> change) {
    super.onChange(change);
  }

  Future<void> updateKalaUserToFirestore() async {
    if (state.id.isNotEmpty) {
      if (firebaseConfig?.auth.currentUser == null) {
        Fluttertoast.showToast(msg: "Log in First");
      }

      var docRef = firebaseConfig?.firestore
          .collection(FirestorePaths.userCollection)
          .doc(state.id);
      if (docRef == null) {
        return;
      }
      DocumentSnapshot userSnapshot = await docRef.get();
      if (userSnapshot.exists) {
        await firebaseConfig?.firestore
            .collection(FirestorePaths.userCollection)
            .doc(state.id)
            .update(state.toMap());
      } else {
        if (firebaseConfig?.firestore is! FakeFirebaseFirestore) {
          FirebaseAnalytics.instance.logSignUp(signUpMethod: state.authType);
        }

        await firebaseConfig?.firestore
            .collection(FirestorePaths.userCollection)
            .doc(state.id)
            .set(state.toMap());
      }

      userSnapshotFetcher();
    }
  }

  void userSnapshotFetcher() async {
    if (state.id.isNotEmpty) {
      firebaseConfig?.firestore
          .collection(FirestorePaths.userCollection)
          .doc(state.id)
          .snapshots()
          .listen((event) {
        KalaUser userFromSnapshot = KalaUser.fromMap(
          event.data()!,
        );
        if (TEST_FLAG) {
          assert(userFromSnapshot.id == "test_id");
        }
        assert(userFromSnapshot.validateUser());
        emit(userFromSnapshot);
      });
    }
  }

  Future<void> authenticateWithSocialAuth(String authType) async {
    KalaUser? kalaUser;
    if (firebaseConfig?.auth is MockFirebaseAuth) {
      UserCredential? userCredential =
          await firebaseConfig?.auth.signInAnonymously();
      assert(userCredential != null);
      kalaUser = KalaUser.fromSocialAuthUser(
        userCredential?.user as User,
        "mock-$authType",
        "$authType-url"
      );
      emit(kalaUser);
      return;
    }
    switch (authType) {
      case "google":
        kalaUser = await signInWithGoogle();
        break;
    }
    if (kalaUser != null) {
      emit(kalaUser);
    }
  }
}
