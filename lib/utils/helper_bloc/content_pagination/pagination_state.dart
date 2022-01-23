import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

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
    this.subDocID,
  });

  final String collection;
  final List<dynamic> data;
  final DocumentSnapshot? lastDocument;
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
    Timestamp? lastFetchedTimestamp,
    String? orderByField,
    bool? orderIsDescending,
    Map<String, dynamic>? whereQueryEquals,
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
      whereQueryEquals: whereQueryEquals ?? this.whereQueryEquals,
      subDocID: subDocID ?? this.subDocID,
      scrollPosition: scrollPosition ?? this.scrollPosition,
    );
  }
}
