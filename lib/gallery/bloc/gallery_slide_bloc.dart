import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/main.dart';

class GallerySlideBloc extends Cubit<GallerySlideState> {
  StreamSubscription<KalaUserState>? kalaUserStateStream;
  GallerySlideBloc({KalaUserBloc? kalaUserBloc})
      : super(GallerySlideState(
          contentSlideList: [],
          viewingIndex: 0,
        )) {
    kalaUserStateStream = kalaUserBloc?.stream.listen((kalaUserState) {
      if (kalaUserState is AuthenticatedKalaUserState) {
        getContentList();
      }
    });
  }

  Future<void> getContentList() async {
    if (TEST_FLAG) {
      emit(GallerySlideState.fakeGalleryState());
    } else {
      emit(GallerySlideState.fakeGalleryState());
    }
  }

  void changeViewingIndex(int index) {
    emit(state.copyWith(viewingIndex: index));
  }
}
