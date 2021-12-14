import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/auth/social_integration/google.dart';
import 'package:kala/main.dart';

class KalaUserBloc extends Cubit<KalaUser> {
  KalaUserBloc()
      : super(KalaUser(
          name: "",
          id: "",
          authType: AuthType.phone,
        ));
  void updateKalaUserToFirestore() async {
    if (state.id.isNotEmpty) {
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

  Future<void> authenticateWithSocialAuth(AuthType authType) async {
    KalaUser? kalaUser;
    switch (authType) {
      case AuthType.google:
        kalaUser = await signInWithGoogle();
        break;
      case AuthType.phone:
        kalaUser = await signInWithGoogle();
        break;
      case AuthType.facebook:
        kalaUser = await signInWithGoogle();
        break;
      case AuthType.instagram:
        kalaUser = await signInWithGoogle();
        break;
      case AuthType.anonymous:
        kalaUser = await signInWithGoogle();
        break;
    }
    if (kalaUser != null) {
      emit(kalaUser);
    }
  }
}
