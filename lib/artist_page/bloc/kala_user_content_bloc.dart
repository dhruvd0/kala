import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_state.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_bloc.dart';

class KalaUserContentCubit extends Cubit<KalaUserContentState> {
  KalaUserContentCubit([this.firebaseFirestore])
      : super(
          KalaUserContentState(
            userContent: const [],
            bio: '',
            coverContent: ContentMock.fakeContent(-1),
          ),
        ) {
    setupUserContentPaginationCubit();
  }

  PaginationCubit? contentPaginationCubit;
  FirebaseFirestore? firebaseFirestore;

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
    var newContent = await contentPaginationCubit?.getTList(scrollPosition);

    if (newContent?.isNotEmpty??false) {
      emit(
        state.copyWith(
          userContent: (newContent??<Content>[]).map((dynamic e) => e as Content).toList(),
          lastFetchedTimestamp: Timestamp.now(),
        ),
      );
    }
  }
}
