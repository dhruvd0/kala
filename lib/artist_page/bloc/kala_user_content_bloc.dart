// ignore_for_file: unawaited_futures, cascade_invocations

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

class KalaUserContentBloc extends Cubit<KalaUserContentState> {
  KalaUserContentBloc({
    required this.kalaUserBloc,
    this.firebaseFirestore,
    this.customStorage,
  }) : super(
          KalaUserContentState(
            userContent: const [],
            bio: 'Empty Bio',
            coverContent: '',
            uid: kalaUserBloc.state.uid,
            isEditMode: false,
          ),
        ) {
    setupKalaUserBlocListener();
  }

  factory KalaUserContentBloc.mock() {
    return KalaUserContentBloc(
      kalaUserBloc: KalaUserBloc.mock(),
      firebaseFirestore: firebaseConfig?.firestore,
      customStorage: firebaseConfig?.storage,
    )..setupUserContentPaginationCubit(FirebaseMocks().firebaseMockUser.uid);
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
              ? FirebaseMocks().firebaseMockUser.uid
              : firebaseConfig?.auth.currentUser?.uid,
        },
      );

  void changeBio(String bio) {
    emit(state.copyWith(bio: bio));
  }

  void changeCover(File image) {
    emit(state.copyWith(coverContent: image));
  }

  Future<void> publishChanges() async {
    if (state.coverContent is File) {
      String? fileName;
      try {
        fileName = (await DefaultCacheManager()
                .getSingleFile(state.coverContentUrl.toString()))
            .basename;
      } on Exception {
        fileName = null;
      }

      final fileDoesNotExistInStorage =
          !(fileName == (state.coverContent as File).path.split('/').last);
      if (fileDoesNotExistInStorage && state.coverContentUrl != null) {
        FirebaseStorageRequest()
            .uploadFile(
          '${FirestorePaths.userCollection}/${state.uid}/cover/${(state.coverContent as File).path.split('/').last}',
          state.coverContent,
        )
            .then(
          (url) {
            if (url.isNotEmpty) {
              updateCoverImageUrl(url);
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

  void updateCoverImageUrl(String url) {
    FirestoreUpdateRequest().update(
      FirestorePaths.userCollection,
      state.uid,
      {
        'coverContent': url,
      },
    );
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
        getUserContent(
          2,
          collectionSegment: CollectionSegment.initial,
        );
      }
    }
  }

  Future<void> getUserContent(
    int scrollPosition, {
    required CollectionSegment collectionSegment,
  }) async {
    assert(contentPaginationCubit != null);

    final newContent = await contentPaginationCubit?.getTList(
      scrollPosition,
      segment: collectionSegment,
    );

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
      newContent?.insert(
        0,
        Content.fromMap(const {}).copyWith(viewMode: ContentViewMode.grid),
      );
    }

    emit(
      state.copyWith(
        isEditMode: forceToggle ?? !state.isEditMode,
        userContent: newContent,
      ),
    );
  }
}
