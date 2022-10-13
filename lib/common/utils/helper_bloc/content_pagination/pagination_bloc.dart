import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/typedefs.dart';

import 'package:kala/common/models/art.dart';
import 'package:kala/common/services/firebase/firestore_get.dart';
import 'package:kala/common/utils/helper_bloc/content_pagination/pagination_state.dart';

class PaginationCubit<T> extends Cubit<PaginationRequestState> {
  PaginationCubit({
    required String collection,
    required bool orderIsDescending,
    required String orderByField,
    required this.dataFromMap,
    Json? whereQueryEquals,
    String? subDocID,
  }) : super(
          PaginationRequestState(
            collection: collection,
            orderIsDescending: orderIsDescending,
            orderByField: orderByField,
            whereQueryEquals: whereQueryEquals,
            subDocID: subDocID,
            scrollPosition: -1,
            lastFetchedTimestamp: Timestamp.now(),
            data: const <dynamic>[],
          ),
        );

  factory PaginationCubit.galleryArtPagination() {
    return PaginationCubit(
      collection: firestorePaths.art,
      orderIsDescending: true,
      dataFromMap: Art.fromMap,
      orderByField: 'uploadTimestamp',
    );
  }

  factory PaginationCubit.userArtPagination(String uid) {
    return PaginationCubit(
      collection: firestorePaths.art,
      orderIsDescending: true,
      orderByField: 'uploadTimestamp',
      dataFromMap: Art.fromMap,
      whereQueryEquals: {'artistID': uid},
    );
  }

  final dynamic Function(Map<String, dynamic>) dataFromMap;

 

  Future<List<Map<String, dynamic>>> getJsonList(
    int scrollPosition, {
    required CollectionSegment segment,
  }) async {
    final firestorePageRequest = state;
    if (isDataFetchedForScrollPosition(scrollPosition, segment)) {
      return [];
    }
    emit(state.copyWith(scrollPosition: scrollPosition));
    final response = await FirestoreQueries().paginateCollectionDocuments(
      firestorePageRequest,
      collectionSegment: segment,
    );
    if (response == null) {
      return [];
    }
    emit(
      state.copyWith(
        lastDocument: response.lastDocSnap,
        firstDocument: response.firstDocSnap,
      ),
    );

    return response.currentJsonList;
  }

  bool isDataFetchedForScrollPosition(
    int scrollPosition,
    CollectionSegment? segment,
  ) {
    return scrollPosition == state.scrollPosition &&
        scrollPosition != 0 &&
        segment == CollectionSegment.next;
  }
}

abstract class HasPaginationCubit<T> extends Cubit<T> {
  HasPaginationCubit(initialState, {required this.paginationCubit})
      : super(initialState);

  PaginationCubit paginationCubit;
}
