import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/typedefs.dart';

import 'package:kala/features/gallery/art/models/art.dart';
import 'package:kala/services/firebase/crashlytics.dart';
import 'package:kala/services/firebase/firestore_get.dart';
import 'package:kala/services/firebase/page_data.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

class PaginationCubit extends Cubit<PaginationRequestState> {
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
      collection: firestorePaths.user,
      orderIsDescending: true,
      orderByField: 'uploadTimestamp',
      dataFromMap: Art.fromMap,
      whereQueryEquals: {'artistID': uid},
    );
  }

  final dynamic Function(Map<String, dynamic>) dataFromMap;

  FirebaseFirestore? firebaseFirestore;

  Future<List<dynamic>> getTList(
    int scrollPosition, {
    required CollectionSegment segment,
  }) async {
    final firestorePageRequest = state;
    if (isDataFetchedForScrollPosition(scrollPosition, segment)) {
      return <dynamic>[];
    }
    emit(state.copyWith(scrollPosition: scrollPosition));
    final response = await FirestoreQueries().paginateCollectionDocuments(
      firestorePageRequest,
      collectionSegment: segment,
    );
    if (response == null) {
      return <dynamic>[];
    }
    emit(
      state.copyWith(
        lastDocument: response.lastDocSnap,
        firstDocument: response.firstDocSnap,
      ),
    );

    final validatedData = validateAndEmitData(
      parseTListFromFirestoreResponse(<dynamic>[
        response,
        state.data,
      ]),
      response,
      segment,
    );
    return validatedData;
  }

  bool isDataFetchedForScrollPosition(
    int scrollPosition,
    CollectionSegment? segment,
  ) {
    return scrollPosition == state.scrollPosition &&
        scrollPosition != 0 &&
        segment == CollectionSegment.next;
  }

  List<dynamic> parseTListFromFirestoreResponse(List<dynamic> args) {
    final newArtList = <dynamic>[];
    final response = args.first as FirestorePageResponse;
    for (final jsonElement in response.currentJsonList) {
      try {
        assert(jsonElement.containsKey('docID'));
        newArtList.add(dataFromMap(jsonElement));
        // ignore: avoid_catching_errors
      } on AssertionError {
        setCrashlyticsCustomKey('doc', jsonElement)
            .then((value) => throw Exception('No docID'));
      }
    }
    final currentList = args.last as List<dynamic>;
    if (newArtList.isNotEmpty && currentList.isNotEmpty) {
      newArtList.removeWhere(
        (dynamic newE) => currentList.any(
          (dynamic element) => newE == element,
        ),
      );
    }

    return newArtList;
  }

  List<dynamic> validateAndEmitData(
    List<dynamic> newDataList,
    FirestorePageResponse response,
    CollectionSegment segment,
  ) {
    if (newDataList.isNotEmpty) {
      // ignore: omit_local_variable_types
      final currentDataList = state.data.toList();
      if (segment == CollectionSegment.previous) {
        for (final e in newDataList.reversed) {
          currentDataList.insert(0, e);
        }
      } else {
        for (final e in newDataList) {
          currentDataList.add(e);
        }
      }

      emit(
        state.copyWith(
          data: currentDataList,
          lastFetchedTimestamp: Timestamp.now(),
        ),
      );
      return currentDataList;
    } else {
      return <dynamic>[];
    }
  }

  void assertionsForNewDataList(List<dynamic> newDataList) {
    assert(state.data.last != newDataList.first);
  }
}

abstract class HasPaginationCubit<T> extends Cubit<T> {
  HasPaginationCubit(initialState, {required this.paginationCubit})
      : super(initialState);

  PaginationCubit paginationCubit;
}
