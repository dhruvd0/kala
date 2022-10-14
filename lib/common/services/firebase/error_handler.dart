import 'dart:io';

import 'package:kala/common/services/firebase/firebase_error.dart';

FirestoreException handleFirestoreError(dynamic e) {
  if (e is SocketException) {
    return NoConnection();
  }
  if (e is DocumentNotFound || e is FirestoreException) {
    return e;
  }
  
  return FirestoreException(message: e.toString());
}
