// ignore_for_file: unawaited_futures, cascade_invocations

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:kala/artist_page/bloc/kala_user_content_state.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/firebase/firebase_storage.dart';
import 'package:kala/utils/firebase/firestore_update.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class KalaUserContentBloc extends Cubit<KalaUserContentState> {
  KalaUserContentBloc({
    required this.kalaUserBloc,
    this.firebaseFirestore,
    this.customStorage,
    String? userID,
  }) : super(
          KalaUserContentState(
            userContent: const [],
            bio: '',
            coverContent: '',
            uid: userID ?? firebaseConfig?.auth.currentUser?.uid ?? '',
            newContent: initialNewContent(),
          ),
        ) {
    setupUserContentPaginationCubit();
  }

  factory KalaUserContentBloc.mock() {
    return KalaUserContentBloc(
      kalaUserBloc: KalaUserBloc(),
      firebaseFirestore: FirebaseMocks.mockFirestore,
      customStorage: FirebaseMocks.mockFirebaseStorage,
    );
  }

  PaginationCubit? contentPaginationCubit;
  FirebaseStorage? customStorage;
  FirebaseFirestore? firebaseFirestore;
  final KalaUserBloc kalaUserBloc;

  static Content initialNewContent() => Content.fromMap(
        <String, dynamic>{
          'artistID': isTestMode
              ? FirebaseMocks.firebaseMockUser.uid
              : firebaseConfig?.auth.currentUser?.uid,
        },
      );

  void changeBio(String bio) {
    emit(state.copyWith(bio: bio));
  }

  void changeCover(File image) {
    emit(state.copyWith(coverContent: image));
  }

  Future<void> editNewContent(ContentProps contentProp, dynamic data) async {
    assert(data != null);
    if (state.newContent.artistName.isEmpty) {
      emit(
        state.copyWith(
          newContent: state.newContent.copyWith(
            artistName: isTestMode
                ? FirebaseMocks.firebaseMockUser.displayName
                : kalaUserBloc.state.kalaUser.name,
          ),
        ),
      );
    }

    switch (contentProp) {
      case ContentProps.title:
        contentStringPropAssertions(data);
        emit(
          state.copyWith(
            newContent: state.newContent.copyWith(
              title: data.toString(),
              uploadTimestamp: Timestamp.now(),
            ),
          ),
        );
        break;
      case ContentProps.price:
        contentIntPropsAssertions(data);
        emit(
          state.copyWith(
            newContent: state.newContent.copyWith(price: data as int),
          ),
        );
        break;
      case ContentProps.image:
        final value = ImageSizeGetter.getSize(FileInput(data));
        emit(
          state.copyWith(
            newContent: state.newContent.copyWith(
              imageFile: data as File,
              fileSize: await data.length(),
              imgHeight: value.height.toDouble(),
              imgWidth: value.width.toDouble(),
            ),
          ),
        );

        break;
      case ContentProps.description:
        contentStringPropAssertions(data);
        emit(
          state.copyWith(
            newContent: state.newContent.copyWith(description: data.toString()),
          ),
        );
        break;
    }
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
    final uploadedContentDocID = await setInitialContentData();
    assert(state.newContent.imageFile != null);
    final imageUrl = await uploadImageAndGetUrl(
      '${FirestorePaths.fakeContentCollection}/$uploadedContentDocID/',
    );
    emitLocalNewContentState(
      imageUrl,
      uploadedContentDocID,
    );
    state.newContent.validate();
    await updateNewContentImageURL(
      uploadedContentDocID,
      imageUrl,
    );

    emit(
      state.copyWith(
        newContent: initialNewContent(),
      ),
    );
  }

  void emitLocalNewContentState(String imageUrl, String uploadedContentDocID) {
    emit(
      state.copyWith(
        newContent: state.newContent.copyWith(
          imageUrl: imageUrl,
          docID: uploadedContentDocID,
        ),
      ),
    );
  }

  Future<void> updateNewContentImageURL(
    String uploadedContentDocID,
    String imageUrl,
  ) async {
    await FirestoreUpdateRequest(firestore: firebaseFirestore).update(
      FirestorePaths.contentCollection,
      uploadedContentDocID,
      <String, String>{'imageURl': imageUrl},
    );
  }

  Future<String> uploadImageAndGetUrl(
    String contentStoragePath,
  ) {
    return FirebaseStorageRequest(customStorage).uploadFile(
      '$contentStoragePath/$correctFilePath',
      state.newContent.imageFile!,
    );
  }

  String? get correctFilePath =>
      state.newContent.imageFile?.path.split('/').last;

  Future<String> setInitialContentData() {
    return FirestoreUpdateRequest(firestore: firebaseFirestore).set(
      FirestorePaths.fakeContentCollection,
      state.newContent.toMap(),
    );
  }

  void publishChanges() {}

  void setupUserContentPaginationCubit() {
    if (firebaseFirestore is FakeFirebaseFirestore) {
      contentPaginationCubit = PaginationCubit.userContentPagination(
        FirebaseMocks.firebaseMockUser.uid,
      );
      contentPaginationCubit?.firestore = firebaseFirestore;
    }
      
    firebaseConfig?.auth.userChanges().asBroadcastStream().listen((user) {
      if (user == null) {
        return;
      }
      
      emit(state.copyWith(uid: user.uid));
      contentPaginationCubit = PaginationCubit.userContentPagination(
       user.uid,
      );
      if (firebaseFirestore != null) {
        contentPaginationCubit?.firestore = firebaseFirestore;
      }
      getUserContent(0);
    });
  }

  Future<File?> scanImage(BuildContext context) async {
    if (await Permission.camera.request().isGranted) {
      try {
        final scannedDoc = await DocumentScannerFlutter.launch(context);
        return scannedDoc;
      } on PlatformException {
        // 'Failed to get document path or operation cancelled!';
      }
    }
  }

  Future<void> getUserContent(int scrollPosition) async {
    assert(contentPaginationCubit != null);
    final newContent = await contentPaginationCubit?.getTList(scrollPosition);

    if (newContent?.isNotEmpty ?? false) {
      emit(
        state.copyWith(
          userContent: (newContent ?? <Content>[])
              .map((dynamic e) {
                return e as Content;
              })
              .toList(),
          lastFetchedTimestamp: Timestamp.now(),
        ),
      );
    }
  }
}
