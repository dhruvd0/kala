import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:kala/common/models/art.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/features/artist_profile/services/artist_content_service.dart';
import 'package:kala/features/artist_profile/upload_art/bloc/upload_art_state.dart';

class UploadArtBloc extends Cubit<UploadArtState> {
  UploadArtBloc(this.artistContentService) : super(UploadArtInitial());
  EditArtState get editArtState => state as EditArtState;
  final ArtistContentService artistContentService;
  String? get correctFilePath =>
      editArtState.art.imageFile?.path.split('/').last;

  Future<void> editNewArt(ArtProps artProp, dynamic data) async {
    assert(data != null);
    if (state is! EditArtState) {
      emit(EditArtState(Art.fromMap(const {})));
    }

    switch (artProp) {
      case ArtProps.title:
        artStringPropAssertions(data);
        emit(
          editArtState.copyWith(
            art: editArtState.art.copyWith(
              title: data.toString(),
              uploadTimestamp: Timestamp.now(),
            ),
          ),
        );
        break;
      case ArtProps.price:
        artIntPropsAssertions(data);
        editArtState.copyWith(
          art: editArtState.art.copyWith(
            price: data as int,
          ),
        );

        break;
      case ArtProps.image:
        final value = ImageSizeGetter.getSize(FileInput(data));
        editArtState.copyWith(
          art: editArtState.art.copyWith(
            imageFile: data as File,
            fileSize: await data.length(),
            imgHeight: value.height.toDouble(),
            imgWidth: value.width.toDouble(),
          ),
        );

        break;
      case ArtProps.description:
        artStringPropAssertions(data);
        editArtState.copyWith(
          art: editArtState.art.copyWith(
            description: data.toString(),
          ),
        );

        break;
    }
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
    if (editArtState.art.artistID.isEmpty) {
      emit(
        editArtState.copyWith(
          art: editArtState.art
              .copyWith(artistID: firebaseConfig.auth.currentUser!.uid),
        ),
      );
    }

    final uploadedArtDocID =
        await artistContentService.setInitialArtData(editArtState.art.toMap());
    assert(uploadedArtDocID.isNotEmpty);
    assert(editArtState.art.imageFile != null);
    final imageUrl = await artistContentService.uploadArtImageToStorage(
      editArtState.art.imageFile!,
      artStoragePath: '${firestorePaths.art}/$uploadedArtDocID/',
      filePath: correctFilePath!,
    );
    emitLocalNewArtState(
      imageUrl,
      uploadedArtDocID,
    );

    if (!editArtState.art.isValid()) {
      throw Exception('Invalid Exception: ${state.toString()}');
    }
    await artistContentService.updateNewArtImageURL(uploadedArtDocID, imageUrl);

    emit(UploadArtSuccess());
  }

  void emitLocalNewArtState(String imageUrl, String uploadedArtDocID) {
    emit(
      editArtState.copyWith(
        art: editArtState.art.copyWith(
          imageUrl: imageUrl,
          docID: uploadedArtDocID,
        ),
      ),
    );
  }
}
