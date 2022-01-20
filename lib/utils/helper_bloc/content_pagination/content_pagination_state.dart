import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/firebase/page_data.dart';
@immutable
class ContentPaginationState {
  const ContentPaginationState({
    required this.lastFetchedTimestamp,
    required this.collection,
    required this.orderByField,
    required this.orderIsDescending,
    required this.content,
    this.lastDocument,
    this.lastPageRequest,
    this.subCollection,
  });

  final String collection;
  final List<Content> content;
  final DocumentSnapshot? lastDocument;
  final Timestamp lastFetchedTimestamp;
  final FirestorePageRequest? lastPageRequest;
  final String orderByField;
  final bool orderIsDescending;
  final String? subCollection;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ContentPaginationState &&
        other.lastDocument == lastDocument &&
        other.lastPageRequest == lastPageRequest &&
        other.lastFetchedTimestamp == lastFetchedTimestamp &&
        other.collection == collection &&
        other.orderByField == orderByField &&
        other.orderIsDescending == orderIsDescending &&
        other.subCollection == subCollection &&
        listEquals(other.content, content);
  }

  @override
  int get hashCode {
    return lastDocument.hashCode ^
        lastPageRequest.hashCode ^
        lastFetchedTimestamp.hashCode ^
        collection.hashCode ^
        orderByField.hashCode ^
        orderIsDescending.hashCode ^
        subCollection.hashCode ^
        content.hashCode;
  }

  @override
  String toString() {
    return 'ContentPaginationState(lastDocument: $lastDocument, lastPageRequest: $lastPageRequest, lastFetchedTimestamp: $lastFetchedTimestamp, collection: $collection, orderByField: $orderByField, orderIsDescending: $orderIsDescending, subCollection: $subCollection, content: $content)';
  }

  ContentPaginationState copyWith({
    DocumentSnapshot? lastDocument,
    FirestorePageRequest? lastPageRequest,
    Timestamp? lastFetchedTimestamp,
    String? collection,
    String? orderByField,
    bool? orderIsDescending,
    String? subCollection,
    List<Content>? content,
  }) {
    return ContentPaginationState(
      lastDocument: lastDocument ?? this.lastDocument,
      lastPageRequest: lastPageRequest ?? this.lastPageRequest,
      lastFetchedTimestamp: lastFetchedTimestamp ?? this.lastFetchedTimestamp,
      collection: collection ?? this.collection,
      orderByField: orderByField ?? this.orderByField,
      orderIsDescending: orderIsDescending ?? this.orderIsDescending,
      subCollection: subCollection ?? this.subCollection,
      content: content ?? this.content,
    );
  }
}
