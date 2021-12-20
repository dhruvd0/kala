import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/auth/social_integration/auth_types.dart';

Future<KalaUser?> signInWithGoogle() async {
  // Trigger the authentication flow
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential = (kIsWeb)
        ? await getGoogleAuthProviderForWeb()
        : await FirebaseAuth.instance.signInWithCredential(credential);
    return KalaUser.fromSocialAuthUser(
      userCredential.user!,
      AuthTypes.google,
      userCredential.user?.email as String,
    );
  } on FirebaseAuthException catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
}

Future<UserCredential> getGoogleAuthProviderForWeb() async {
  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);
}
