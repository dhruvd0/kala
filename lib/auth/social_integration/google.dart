import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/auth/social_integration/auth_types.dart';

Future<KalaUser?> signInWithGoogle() async {
  // Trigger the authentication flow

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
  return KalaUser.fromSocialAuthUser(
    userCredential.user!,
    authType: AuthTypes.google,
  );
}

Future<UserCredential> getGoogleAuthProviderForWeb() async {
  // Create a new provider
  final googleProvider = GoogleAuthProvider();

  googleProvider
      .addScope('https://www.googleapis.com/auth/contacts.readonly')
      .setCustomParameters(<String, String>{'login_hint': 'user@example.com'});

  return FirebaseAuth.instance.signInWithPopup(googleProvider);
}
