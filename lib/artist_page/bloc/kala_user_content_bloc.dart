// ignore_for_file: unawaited_futures, cascade_invocations

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:kala/artist_page/bloc/kala_user_content_state.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/models/kala_user.dart';

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
  })  : super(
          KalaUserContentState(
            userContent: const [],
            bio: 'Empty Bio',
            coverContent: '',
            uid: kalaUserBloc.state.uid,
            newContent: initialNewContent(),
            isEditMode: false,
          ),
        ) {
    setupKalaUserBlocListener();
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
  StreamSubscription<KalaUser>? kalaUserStream;

  @override
  Future<void> close() async {
    kalaUserStream?.cancel();
    super.close();
  }

  @override
  void onChange(Change<KalaUserContentState> change) {
    if (change.currentState.isEditMode == true &&
        change.nextState.isEditMode == false) {
      publishChanges();
    }
    super.onChange(change);
  }

  Future<void> loadCoverImageFromCache() async {
    if (state.isContentImageUrlValid()) {
      final fileInfo = await DefaultCacheManager()
          .getFileFromCache(state.coverContent.toString());

      if (fileInfo?.file != null) {
        emit(state.copyWith(coverContent: fileInfo?.file));
      }
    }
  }

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
                : kalaUserBloc.state.name,
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
      '${FirestorePaths.contentCollection}/$uploadedContentDocID/',
    );
    emitLocalNewContentState(
      imageUrl,
      uploadedContentDocID,
    );

    if (!state.newContent.isValid()) {
      throw Exception('Invalid Exception: ${state.newContent.toString()}');
    }
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
  ) async {
    return FirebaseStorageRequest(customStorage).uploadFile(
      '$contentStoragePath/$correctFilePath',
      state.newContent.imageFile!,
    );
  }

  String? get correctFilePath =>
      state.newContent.imageFile?.path.split('/').last;

  Future<String> setInitialContentData() {
    return FirestoreUpdateRequest(firestore: firebaseFirestore).set(
      FirestorePaths.contentCollection,
      state.newContent.toMap(),
    );
  }

  Future<void> publishChanges() async {
    if (state.coverContent is File) {
      final fileName = (await DefaultCacheManager()
              .getSingleFile(state.coverContentUrl.toString()))
          .basename;

      final fileDoesNotExistInStorage =
          !(fileName == (state.coverContent as File).path.split('/').last);
      if (fileDoesNotExistInStorage && state.coverContentUrl != null) {
        FirebaseStorageRequest()
            .uploadFile(
          '${FirestorePaths.userCollection}/${state.uid}/cover/${(state.coverContent as File).path}',
          state.coverContent,
        )
            .then(
          (url) {
            if (url.isNotEmpty) {
              FirestoreUpdateRequest().update(
                FirestorePaths.userCollection,
                state.uid,
                {
                  'coverContent': url,
                },
              );
            }
          },
        );
      }
    }
    if (state.bio != kalaUserBloc.state.userMapData['bio']) {
      await FirestoreUpdateRequest()
          .update(FirestorePaths.userCollection, state.uid, {
        'bio': state.bio,
      });
    }
    if (kalaUserBloc.state.name != kalaUserBloc.state.userMapData['name']) {
      await FirestoreUpdateRequest()
          .update(FirestorePaths.userCollection, state.uid, {
        'name': kalaUserBloc.state.name,
      });
    }
  }

  void setupUserContentPaginationCubit([String? customUid]) {
    contentPaginationCubit = PaginationCubit.userContentPagination(
      customUid ??
          firebaseConfig?.auth.currentUser?.uid ??
          kalaUserBloc.state.uid,
    );
    if (firebaseFirestore != null) {
      contentPaginationCubit?.firestore = firebaseFirestore;
    }
  }

  void setupKalaUserBlocListener() {
    if (kalaUserBloc.state.kalaUserState == KalaUserState.active) {
      handleKalaUserState(kalaUserBloc.state);
    }
    kalaUserStream =
        kalaUserBloc.stream.asBroadcastStream().listen(handleKalaUserState);
  }

  void handleKalaUserState(KalaUser userState) {
    if (userState.kalaUserState == KalaUserState.active) {
      final userContent = state.userContent;
      var kalaUserContentState =
          KalaUserContentState.fromMap(userState.userMapData);
      if (kalaUserContentState.userContent?.isEmpty ?? false) {
        kalaUserContentState =
            kalaUserContentState.copyWith(userContent: userContent);
      }

      emit(kalaUserContentState);
      setupUserContentPaginationCubit();
      loadCoverImageFromCache();
      if (userContent?.isEmpty ?? false) {
        getUserContent(2);
      }
    }
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
          userContent: (newContent ?? <Content>[]).map((dynamic e) {
            return (e as Content).copyWith(viewMode: ContentViewMode.grid);
          }).toList(),
          lastFetchedTimestamp: Timestamp.now(),
        ),
      );
    }
  }

  void toggleEditMode({bool? forceToggle}) {
   // ignore: prefer_final_locals
   var newContent = state.userContent?.toList();
    if (state.isEditMode) {
      newContent?.removeWhere((element) => !element.isValid());
    } else {
      newContent?.insert(0, Content.fromMap(const {}));
    }

    emit(
      state.copyWith(
        isEditMode: forceToggle ?? !state.isEditMode,
        userContent: newContent,
      ),
    );
  }
}
