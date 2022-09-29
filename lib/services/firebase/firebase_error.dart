// ignore_for_file: public_member_api_docs, sort_constructors_first

class FirestoreException implements Exception {
  final String message;
  FirestoreException({
    required this.message,
  });
}

class NoConnection extends FirestoreException {
  NoConnection() : super(message: 'No Internet');
}

class DocumentNotFound extends FirestoreException {
  DocumentNotFound() : super(message: 'Document not found');
}
