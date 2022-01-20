class FirestorePaths {
  static const String contentCollection = 'content';
  static const String fakeContentCollection = 'fake_content';
  static const String userCollection = 'users';
  static const FirestoreUserPaths userPaths= FirestoreUserPaths();
}

class FirestoreUserPaths {
   const FirestoreUserPaths();

   String get userContent => 'user_content';
}
