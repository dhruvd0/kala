
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/config/typedefs.dart';
@immutable
class FirestorePageResponse {
  const FirestorePageResponse({
    required this.currentJsonList,
    required this.lastDocSnap,
  });

  final List<Json> currentJsonList;
  final DocumentSnapshot? lastDocSnap;

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
      'FirestorePageData(currentJsonList: $currentJsonList, lastDocSnap: $lastDocSnap)';

  FirestorePageResponse copyWith({
    List<Json>? currentJsonList,
    DocumentSnapshot? lastDocSnap,
  }) {
    return FirestorePageResponse(
      currentJsonList: currentJsonList ?? this.currentJsonList,
      lastDocSnap: lastDocSnap ?? this.lastDocSnap,
    );
  }
}
@immutable
class FirestorePageRequest {
  const FirestorePageRequest({
    required this.collection,
    required this.orderByField,
    required this.orderIsDescending,
    this.subCollection,
    this.lastDocSnap,
  });

  final String collection;
  final DocumentSnapshot? lastDocSnap;
  final String orderByField;
  final bool orderIsDescending;
  final String? subCollection;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FirestorePageRequest &&
        other.collection == collection &&
        other.orderByField == orderByField &&
        other.lastDocSnap == lastDocSnap;
  }

  @override
  int get hashCode =>
      collection.hashCode ^ orderByField.hashCode ^ lastDocSnap.hashCode;

  @override
  String toString() =>
      'FirestorePageRequest(collection: $collection, orderByField: $orderByField, lastDocSnap: $lastDocSnap)';

  FirestorePageRequest copyWith({
    String? collection,
    String? orderByField,
    bool? orderIsDescending,
    DocumentSnapshot? lastDocSnap,
  }) {
    return FirestorePageRequest(
      collection: collection ?? this.collection,
      orderByField: orderByField ?? this.orderByField,
      orderIsDescending: orderIsDescending ?? this.orderIsDescending,
      lastDocSnap: lastDocSnap ?? this.lastDocSnap,
    );
  }
}
