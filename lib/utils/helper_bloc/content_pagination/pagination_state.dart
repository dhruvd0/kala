import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class PaginationRequestState extends Equatable {
  PaginationRequestState({
    required this.collection,
    required this.data,
    this.lastDocument,
    required this.lastFetchedTimestamp,
    required this.orderByField,
    required this.orderIsDescending,
    this.whereQueryEquals,
    this.subDocID,
    required this.scrollPosition
  });

  final String collection;
  final List<dynamic> data;
  final DocumentSnapshot? lastDocument;
  final Timestamp lastFetchedTimestamp;
  final String orderByField;
  final bool orderIsDescending;
  int scrollPosition = 0;
  final Map<String,dynamic>? whereQueryEquals;
  final String? subDocID;


  PaginationRequestState copyWith({
    String? collection,
    List<dynamic>? data,
    DocumentSnapshot? lastDocument,
    Timestamp? lastFetchedTimestamp,
    String? orderByField,
    bool? orderIsDescending,
    Map<String,dynamic>? whereQueryEquals,
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
      scrollPosition:scrollPosition??this.scrollPosition
    );
  }

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
}
