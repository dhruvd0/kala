import 'dart:io';

import 'package:kala/services/firebase/firebase_error.dart';

FirestoreException handleFirestoreError(dynamic e) {
  if (e is SocketException) {
    return NoConnection();
  }
  if (e is DocumentNotFound) {
    return e;
  }
  return FirestoreException(message: e.toString());
}
