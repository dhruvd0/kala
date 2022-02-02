import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kala/main.dart';

class FirestoreUpdateRequest {
  FirestoreUpdateRequest({this.firestore}) {
    firestore = firestore ?? firebaseConfig!.firestore;
    assert(firestore != null);
  }

  FirebaseFirestore? firestore;

  Future<String> update(
    String collection,
    String? docID,
    Map<String, dynamic> data,
  ) async {
    try {
      final doc = firestore!.collection(collection).doc(docID);
      await doc.update(data);
      return doc.id;
    } on Exception catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      return '';
    }
  }

  Future<String> set(
    String collection,
    Map<String, dynamic> data, {
    String? docID,
  }) async {
    try {
      final doc = firestore?.collection(collection).doc(docID);
      await doc?.set(data);
      return doc!.id;
    } on Exception catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      return '';
    }
  }
}
