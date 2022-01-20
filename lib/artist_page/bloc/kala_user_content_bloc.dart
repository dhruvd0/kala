// ignore_for_file: unawaited_futures

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_state.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/firebase/firebase_storage.dart';
import 'package:kala/utils/firebase/firestore_update.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_bloc.dart';

class KalaUserContentCubit extends Cubit<KalaUserContentState> {
  KalaUserContentCubit(this.kalaUserBloc, [this.firebaseFirestore])
      : super(
          KalaUserContentState(
            userContent: const [],
            bio: '',
            coverContent: '',
            newContent: initialNewContent(),
          ),
        ) {
    setupUserContentPaginationCubit();
  }

  PaginationCubit? contentPaginationCubit;
  FirebaseFirestore? firebaseFirestore;
  final KalaUserBloc kalaUserBloc;

  static Content initialNewContent() => Content.fromMap(
        <String, dynamic>{
          'artistID': TEST_FLAG
              ? FirebaseMocks.firebaseMockUser.uid
              : firebaseConfig?.auth?.currentUser?.uid,
        },
      );

  void changeBio(String bio) {
    emit(state.copyWith(bio: bio));
  }

  void changeCover(File image) {
    emit(state.copyWith(coverContent: image));
  }

  Future<void> editNewContent(ContentProps contentProp, dynamic data) async {
    switch (contentProp) {
      case ContentProps.title:
        contentStringPropAssertions(data);
        emit(
          state.copyWith(
            newContent: state.newContent.copyWith(title: data.toString()),
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
        emit(
          state.copyWith(
            newContent: state.newContent.copyWith(
              imageFile: data as File,
              fileSize: await data.length(),
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
    final userCollectionPath =
        '/$FirestorePaths.userCollection/${firebaseConfig?.auth.currentUser?.uid}/content}';
    final uploadedContentDocID = await setInitialContentData();
    assert(state.newContent.imageFile != null);
    final imageUrl = await uploadImageAndGetUrl(
      userCollectionPath,
      uploadedContentDocID,
    );
    emitLocalNewContentState(
      imageUrl,
      uploadedContentDocID,
    );
    updateNewContentImageURL(
      uploadedContentDocID,
      imageUrl,
    );
    addContentToUserContentCollection(
      userCollectionPath,
      uploadedContentDocID,
    );

    emit(state.copyWith(newContent: initialNewContent()));
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
    emit(
      state.copyWith(
        userContent: state.userContent..insert(0, state.newContent),
      ),
    );
  }

  Future<void> addContentToUserContentCollection(
    String userCollectionPath,
    String uploadedContentDocID,
  ) async {
    await FirestoreUpdateRequest(firestore: firebaseFirestore).set(
      userCollectionPath,
      state.newContent.toMap()
        ..addAll(<String, dynamic>{'docID': uploadedContentDocID}),
      docID: uploadedContentDocID,
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
    String userCollectionPath,
    String uploadedContentDocID,
  ) {
    return FirebaseStorageRequest(FirebaseStorage.instance).uploadFile(
      '$userCollectionPath/$uploadedContentDocID',
      state.newContent.imageFile!,
    );
  }

  Future<String> setInitialContentData() {
    return FirestoreUpdateRequest(firestore: firebaseFirestore).set(
      FirestorePaths.contentCollection,
      state.newContent.toMap(),
    );
  }

  void publishChanges() {}

  void setupUserContentPaginationCubit() {
    if (firebaseFirestore is FakeFirebaseFirestore) {
      contentPaginationCubit = PaginationCubit.userContentPagination(
        FirebaseMocks.firebaseMockUser.uid,
      );
      contentPaginationCubit?.changeFirestore(firebaseFirestore!);
    }
    firebaseConfig?.auth.userChanges().asBroadcastStream().listen((event) {
      contentPaginationCubit = PaginationCubit.userContentPagination(
        FirebaseMocks.firebaseMockUser.uid,
      );
      if (firebaseFirestore != null) {
        contentPaginationCubit?.changeFirestore(firebaseFirestore!);
      }
      getUserContent(0);
    });
  }

  Future<void> getUserContent(int scrollPosition) async {
    assert(contentPaginationCubit != null);
    final newContent = await contentPaginationCubit?.getTList(scrollPosition);

    if (newContent?.isNotEmpty ?? false) {
      emit(
        state.copyWith(
          userContent: (newContent ?? <Content>[])
              .map((dynamic e) => e as Content)
              .toList(),
          lastFetchedTimestamp: Timestamp.now(),
        ),
      );
    }
  }
}
