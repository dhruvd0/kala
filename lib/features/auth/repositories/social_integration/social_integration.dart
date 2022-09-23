import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kala/features/auth/models/kala_user.dart';

enum AuthTypes {
  google('Google'),
  instagram('Instagram'),
  facebook('Facebook');

  final String name;
  const AuthTypes(this.name);
}

class SocialSignIn {
  Future<Either<FirebaseAuthException, KalaUser>> signInWithGoogle() async {
    // Trigger the authentication flow

    try {
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = kIsWeb
          ? await getGoogleAuthProviderForWeb()
          : await FirebaseAuth.instance.signInWithCredential(credential);
      return right(
        KalaUser.fromSocialAuthUser(
          userCredential.user!,
          authType: AuthTypes.google.name,
        ),
      );
    } on FirebaseAuthException catch (e) {
      return left(e);
    }
  }

  Future<UserCredential> getGoogleAuthProviderForWeb() async {
    // Create a new provider
    final googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly')
        .setCustomParameters(
      <String, String>{'login_hint': 'user@example.com'},
    );

    return FirebaseAuth.instance.signInWithPopup(googleProvider);
  }
}
