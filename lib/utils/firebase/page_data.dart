
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/config/typedefs.dart';

@immutable
class FirestorePageResponse {
  const FirestorePageResponse({
    required this.currentJsonList,
    required this.lastDocSnap,
    required this.firstDocSnap,
  });

  final List<Json> currentJsonList;
  final DocumentSnapshot? lastDocSnap;
  final DocumentSnapshot? firstDocSnap;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FirestorePageResponse &&
        listEquals(other.currentJsonList, currentJsonList) &&
        other.lastDocSnap == lastDocSnap;
  }

  @override
  int get hashCode => currentJsonList.hashCode ^ lastDocSnap.hashCode;

  @override
  String toString() =>
      'FirestorePageResponse(currentJsonList: $currentJsonList, lastDocSnap: $lastDocSnap, firstDocSnap: $firstDocSnap)';

  FirestorePageResponse copyWith({
    List<Json>? currentJsonList,
    DocumentSnapshot? lastDocSnap,
    DocumentSnapshot? firstDocSnap,
  }) {
    return FirestorePageResponse(
      currentJsonList: currentJsonList ?? this.currentJsonList,
      lastDocSnap: lastDocSnap ?? this.lastDocSnap,
      firstDocSnap: firstDocSnap ?? this.firstDocSnap,
    );
  }
}
