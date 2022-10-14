import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/common/models/art.dart';
import 'package:kala/common/services/firebase/firebase_storage.dart';
import 'package:kala/common/services/firebase/firestore_update.dart';
import 'package:kala/features/artist_content/upload_art/bloc/upload_art_state.dart';

class UploadArtBloc extends Cubit<UploadArtState> {
  UploadArtBloc() : super(UploadArtInitial(Art.fromMap(const {})));
  EditArtState get editArtState => state as EditArtState;
  Future<String> uploadImageAndGetUrl(
    String artStoragePath,
  ) async {
    return FirebaseStorageRequest(firebaseConfig.storage).uploadFile(
      '$artStoragePath/$correctFilePath',
      editArtState.art.imageFile!,
    );
  }

  String? get correctFilePath => editArtState.art.imageFile?.path.split('/').last;

  Future<String> setInitialArtData() {
    return FirestoreUpdateRequest(firestore: firebaseConfig.firestore).set(
      firestorePaths.art,
      editArtState.art.toMap(),
    );
  }

  Future<void> editNewArt(ArtProps artProp, dynamic data) async {
    assert(data != null);
  

    switch (artProp) {
      case ArtProps.title:
        artStringPropAssertions(data);
        emit(
          state.copyWith(
            title: data.toString(),
            uploadTimestamp: Timestamp.now(),
          ),
        );
        break;
      case ArtProps.price:
        artIntPropsAssertions(data);
        emit(
          state.copyWith(
            price: data as int,
          ),
        );

        break;
      case ArtProps.image:
        final value = ImageSizeGetter.getSize(FileInput(data));
        emit(
          state.copyWith(
            imageFile: data as File,
            fileSize: await data.length(),
            imgHeight: value.height.toDouble(),
            imgWidth: value.width.toDouble(),
          ),
        );

        break;
      case ArtProps.description:
        artStringPropAssertions(data);
        emit(
          state.copyWith(description: data.toString()),
        );
        break;
    }
  }

  Future<void> updateNewArtImageURL(
    String uploadedArtDocID,
    String imageUrl,
  ) async {
    await FirestoreUpdateRequest(firestore: firebaseConfig.firestore).update(
      firestorePaths.art,
      uploadedArtDocID,
      <String, String>{'imageUrl': imageUrl, 'docID': uploadedArtDocID},
    );
    // if (state.coverArtUrl?.isEmpty ?? false) {
    //   updateCoverImageUrl(imageUrl);
    // }
  }

  void artIntPropsAssertions(dynamic data) {
    assert(data is int);
    assert((data as int) >= 0);
  }

  void artStringPropAssertions(dynamic data) {
    assert(data is String);
    assert(data.toString().isNotEmpty);
  }

  Future<void> addNewArt() async {
    // TODO(dhruv): artist id
    // if (state.artistID.isEmpty) {
    //   emit(state.copyWith(artistID: kalaUserArt.kalaUserBloc.state.uid));
    // }
    assert(state.artistID.isNotEmpty);
    final uploadedArtDocID = await setInitialArtData();
    assert(uploadedArtDocID.isNotEmpty);
    assert(state.imageFile != null);
    final imageUrl = await uploadImageAndGetUrl(
      '${firestorePaths.art}/$uploadedArtDocID/',
    );
    emitLocalNewArtState(
      imageUrl,
      uploadedArtDocID,
    );

    if (!state.isValid()) {
      throw Exception('Invalid Exception: ${state.toString()}');
    }
    await updateNewArtImageURL(
      uploadedArtDocID,
      imageUrl,
    );

    emit(
      Art.fromMap(const {}),
    );
  }

  void emitLocalNewArtState(String imageUrl, String uploadedArtDocID) {
    emit(
      state.copyWith(
        imageUrl: imageUrl,
        docID: uploadedArtDocID,
      ),
    );
  }
}
