import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/config/typedefs.dart';

class FirestorePageResponse {
  final List<Json> currentJsonList;
  final DocumentSnapshot? lastDocSnap;
  FirestorePageResponse({
    required this.currentJsonList,
    required this.lastDocSnap,
  });

  FirestorePageResponse copyWith({
    List<Json>? currentJsonList,
    DocumentSnapshot? lastDocSnap,
  }) {
    return FirestorePageResponse(
      currentJsonList: currentJsonList ?? this.currentJsonList,
      lastDocSnap: lastDocSnap ?? this.lastDocSnap,
    );
  }

  @override
  String toString() =>
      'FirestorePageData(currentJsonList: $currentJsonList, lastDocSnap: $lastDocSnap)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FirestorePageResponse &&
        listEquals(other.currentJsonList, currentJsonList) &&
        other.lastDocSnap == lastDocSnap;
  }

  @override
  int get hashCode => currentJsonList.hashCode ^ lastDocSnap.hashCode;
}

class FirestorePageRequest {
  final String collection;
  final String orderByField;
  final bool orderIsDescending;
  final String? subCollection;
  final DocumentSnapshot? lastDocSnap;

  FirestorePageRequest({
    required this.collection,
    required this.orderByField,
    required this.orderIsDescending,
    this.subCollection,
    this.lastDocSnap,
  });

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

  @override
  String toString() =>
      'FirestorePageRequest(collection: $collection, orderByField: $orderByField, lastDocSnap: $lastDocSnap)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FirestorePageRequest &&
        other.collection == collection &&
        other.orderByField == orderByField &&
        other.lastDocSnap == lastDocSnap;
  }

  @override
  int get hashCode =>
      collection.hashCode ^ orderByField.hashCode ^ lastDocSnap.hashCode;
}
