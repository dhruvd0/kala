import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/auth/social_integration/google.dart';
import 'package:kala/main.dart';

class KalaUserBloc extends Cubit<KalaUser> {
  KalaUserBloc()
      : super(
          KalaUser(
            name: "",
            id: "",
            authType: "",
            photo_url: "",
          ),
        );
  void updateKalaUserToFirestore() async {
    if (state.id.isNotEmpty) {
      if (firebaseConfig?.firebaseAuthInstance.currentUser == null) {
        Fluttertoast.showToast(msg: "Log in First");
      }

      var docRef =
          firebaseConfig?.firestoreInstance.collection("users").doc(state.id);
      if (docRef == null) {
        return;
      }
      DocumentSnapshot userSnapshot = await docRef.get();
      if (userSnapshot.exists) {
        await docRef.update(state.toMap());
      } else {
        await docRef.set(state.toMap());
      }
    }
  }

  void userSnapshotFetcher() async {
    if (state.id.isNotEmpty) {
      firebaseConfig?.firestoreInstance
          .collection("users")
          .doc(state.id)
          .snapshots()
          .listen((event) {
        KalaUser userFromSnapshot = KalaUser.fromMap(
          event.data()!,
        );
        emit(userFromSnapshot);
      });
    }
  }

  Future<void> authenticateWithSocialAuth(String authType) async {
    KalaUser? kalaUser;
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
