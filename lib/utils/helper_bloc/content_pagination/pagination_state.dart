import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum CollectionSegment { initial, previous, next }

class PaginationRequestState extends Equatable {
  const PaginationRequestState({
    required this.collection,
    required this.data,
    required this.lastFetchedTimestamp,
    required this.orderByField,
    required this.orderIsDescending,
    required this.scrollPosition,
    this.lastDocument,
    this.whereQueryEquals,
    this.firstDocument,
    this.subDocID,
  });

  final String collection;
  final List<dynamic> data;
  final DocumentSnapshot? lastDocument;
  final DocumentSnapshot? firstDocument;
  final Timestamp lastFetchedTimestamp;
  final String orderByField;
  final bool orderIsDescending;
  final int scrollPosition;
  final String? subDocID;
  final Map<String, dynamic>? whereQueryEquals;

  @override
  List<dynamic> get props {
    return [
      collection,
      data,
      lastDocument,
      firstDocument,
      lastFetchedTimestamp,
      orderByField,
      orderIsDescending,
      whereQueryEquals,
      subDocID,
    ];
  }

  PaginationRequestState copyWith({
    String? collection,
    List<dynamic>? data,
    DocumentSnapshot? lastDocument,
    DocumentSnapshot? firstDocument,
    Timestamp? lastFetchedTimestamp,
    String? orderByField,
    bool? orderIsDescending,
    int? scrollPosition,
    String? subDocID,
    Map<String, dynamic>? whereQueryEquals,
  }) {
    return PaginationRequestState(
      collection: collection ?? this.collection,
      data: data ?? this.data,
      lastDocument: lastDocument ?? this.lastDocument,
      firstDocument: firstDocument ?? this.firstDocument,
      lastFetchedTimestamp: lastFetchedTimestamp ?? this.lastFetchedTimestamp,
      orderByField: orderByField ?? this.orderByField,
      orderIsDescending: orderIsDescending ?? this.orderIsDescending,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      subDocID: subDocID ?? this.subDocID,
      whereQueryEquals: whereQueryEquals ?? this.whereQueryEquals,
    );
  }
}
