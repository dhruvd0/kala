import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/features/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/features/gallery/content/models/content.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/firebase/firebase_storage.dart';
import 'package:kala/utils/firebase/firestore_update.dart';

class AddNewContentCubit extends Cubit<Content> {
  AddNewContentCubit({
    required this.kalaUserContent,
    this.customStorage,
    this.firebaseFirestore,
  }) : super(Content.fromMap(const {})) {
    kalaUserContent.stream.asBroadcastStream().listen((event) {
      if (isClosed) {
        return;
      }
      emit(state.copyWith(artistID: event.uid));
    });
  }

  factory AddNewContentCubit.mock() {
    return AddNewContentCubit(
      kalaUserContent: KalaUserContentBloc.mock(),
      firebaseFirestore: firebaseConfig?.firestore,
      customStorage: firebaseConfig?.storage,
    );
  }

  FirebaseStorage? customStorage;
  FirebaseFirestore? firebaseFirestore;
  final KalaUserContentBloc kalaUserContent;

  Future<String> uploadImageAndGetUrl(
    String contentStoragePath,
  ) async {
    return FirebaseStorageRequest(customStorage).uploadFile(
      '$contentStoragePath/$correctFilePath',
      state.imageFile!,
    );
  }

  String? get correctFilePath => state.imageFile?.path.split('/').last;

  Future<String> setInitialContentData() {
    return FirestoreUpdateRequest(firestore: firebaseFirestore).set(
      FirestorePaths.contentCollection,
      state.toMap(),
    );
  }

  Future<void> editNewContent(ContentProps contentProp, dynamic data) async {
    assert(data != null);
    if (state.artistName.isEmpty) {
      emit(
        state.copyWith(
          artistName: kalaUserContent.kalaUserBloc.state.name,
        ),
      );
    }

    switch (contentProp) {
      case ContentProps.title:
        contentStringPropAssertions(data);
        emit(
          state.copyWith(
            title: data.toString(),
            uploadTimestamp: Timestamp.now(),
          ),
        );
        break;
      case ContentProps.price:
        contentIntPropsAssertions(data);
        emit(
          state.copyWith(
            price: data as int,
          ),
        );

        break;
      case ContentProps.image:
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
      case ContentProps.description:
        contentStringPropAssertions(data);
        emit(
          state.copyWith(description: data.toString()),
        );
        break;
    }
  }

  Future<void> updateNewContentImageURL(
    String uploadedContentDocID,
    String imageUrl,
  ) async {
    await FirestoreUpdateRequest(firestore: firebaseFirestore).update(
      FirestorePaths.contentCollection,
      uploadedContentDocID,
      <String, String>{'imageUrl': imageUrl, 'docID': uploadedContentDocID},
    );
    // if (state.coverContentUrl?.isEmpty ?? false) {
    //   updateCoverImageUrl(imageUrl);
    // }
  }

  void contentIntPropsAssertions(dynamic data) {
    assert(data is int);
    assert((data as int) >= 0);
  }

  void contentStringPropAssertions(dynamic data) {
    assert(data is String);
    assert(data.toString().isNotEmpty);
  }

  Future<void> addNewContent() async {
    if (state.artistID.isEmpty) {
      emit(state.copyWith(artistID: kalaUserContent.kalaUserBloc.state.uid));
    }
    assert(state.artistID.isNotEmpty);
    final uploadedContentDocID = await setInitialContentData();
    assert(uploadedContentDocID.isNotEmpty);
    assert(state.imageFile != null);
    final imageUrl = await uploadImageAndGetUrl(
      '${FirestorePaths.contentCollection}/$uploadedContentDocID/',
    );
    emitLocalNewContentState(
      imageUrl,
      uploadedContentDocID,
    );

    if (!state.isValid()) {
      throw Exception('Invalid Exception: ${state.toString()}');
    }
    await updateNewContentImageURL(
      uploadedContentDocID,
      imageUrl,
    );

    emit(
      Content.fromMap(const {}),
    );
  }

  void emitLocalNewContentState(String imageUrl, String uploadedContentDocID) {
    emit(
      state.copyWith(
        imageUrl: imageUrl,
        docID: uploadedContentDocID,
      ),
    );
  }
}
