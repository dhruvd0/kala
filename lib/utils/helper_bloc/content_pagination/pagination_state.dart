import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PaginationRequestState {
  PaginationRequestState({
    required this.collection,
    required this.data,
    required this.lastFetchedTimestamp,
    required this.orderByField,
    required this.orderIsDescending,
    this.scrollPosition,
    this.lastDocument,
    this.subCollection,
    this.subDocID,
  });

  final String collection;
  final List<dynamic> data;
  final DocumentSnapshot? lastDocument;
  final Timestamp lastFetchedTimestamp;
  final String orderByField;
  final bool orderIsDescending;
  int? scrollPosition = 0;
  final String? subCollection;
  final String? subDocID;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PaginationRequestState &&
        other.collection == collection &&
        listEquals<dynamic>(other.data, data) &&
        other.lastDocument == lastDocument &&
        other.lastFetchedTimestamp == lastFetchedTimestamp &&
        other.orderByField == orderByField &&
        other.orderIsDescending == orderIsDescending &&
        other.subCollection == subCollection &&
        other.subDocID == subDocID;
  }

  @override
  int get hashCode {
    return collection.hashCode ^
        data.hashCode ^
        lastDocument.hashCode ^
        lastFetchedTimestamp.hashCode ^
        orderByField.hashCode ^
        orderIsDescending.hashCode ^
        subCollection.hashCode ^
        subDocID.hashCode;
  }

  @override
  String toString() {
    return 'PaginationRequestState(collection: $collection, data: $data, lastDocument: $lastDocument, lastFetchedTimestamp: $lastFetchedTimestamp, orderByField: $orderByField, orderIsDescending: $orderIsDescending, subCollection: $subCollection, subDocID: $subDocID)';
  }

  PaginationRequestState copyWith({
    String? collection,
    List<dynamic>? data,
    DocumentSnapshot? lastDocument,
    Timestamp? lastFetchedTimestamp,
    String? orderByField,
    bool? orderIsDescending,
    String? subCollection,
    String? subDocID,
    int? scrollPosition,
  }) {
    return PaginationRequestState(
      collection: collection ?? this.collection,
      data: data ?? this.data,
      lastDocument: lastDocument ?? this.lastDocument,
      lastFetchedTimestamp: lastFetchedTimestamp ?? this.lastFetchedTimestamp,
      orderByField: orderByField ?? this.orderByField,
      orderIsDescending: orderIsDescending ?? this.orderIsDescending,
      subCollection: subCollection ?? this.subCollection,
      subDocID: subDocID ?? this.subDocID,
      scrollPosition: scrollPosition ?? this.scrollPosition,
    );
  }
}
