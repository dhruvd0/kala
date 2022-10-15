import 'dart:io';

import 'package:kala/common/models/art.dart';
import 'package:kala/common/services/firebase/firebase_storage.dart';
import 'package:kala/common/services/firebase/firestore_api.dart';
import 'package:kala/common/utils/helper_bloc/content_pagination/pagination_bloc.dart';
import 'package:kala/common/utils/helper_bloc/content_pagination/pagination_state.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firestore_paths.dart';

import 'package:kala/config/typedefs.dart';

class ArtistContentService extends FirestoreAPI {
  ArtistContentService(this.artistID) {
    paginationCubit = PaginationCubit.userArtPagination(artistID);
  }
  final String artistID;
  late PaginationCubit<Art> paginationCubit;
  Future<List<Map<String, dynamic>>> getUserArt(
    int scrollPosition,
  ) async {
    final userArtJson = await paginationCubit.getJsonList(
      scrollPosition,
      segment: scrollPosition == 0
          ? CollectionSegment.initial
          : CollectionSegment.next,
    );

    return userArtJson;
  }

  Future<String> uploadArtImageToStorage(
    File imageFile, {
    required String artStoragePath,
    required String filePath,
  }) async {
    return FirebaseStorageRequest(firebaseConfig.storage).uploadFile(
      '$artStoragePath/$filePath',
      imageFile,
    );
  }

  Future<String> setInitialArtData(Json json) {
    return set(firestorePaths.art, json);
  }

  Future<void> updateNewArtImageURL(
    String uploadedArtDocID,
    String imageUrl,
  ) async {
    await update(
      firestorePaths.art,
      uploadedArtDocID,
      <String, String>{'imageUrl': imageUrl, 'docID': uploadedArtDocID},
    );
  }
}
