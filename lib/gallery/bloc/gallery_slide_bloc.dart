import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';

class GallerySlideBloc extends Cubit<GallerySlideState> {
  StreamSubscription<KalaUserState>? kalaUserStateStream;
  GallerySlideBloc({KalaUserBloc? kalaUserBloc})
      : super(GallerySlideState(contentSlideList: [])) {
    kalaUserStateStream = kalaUserBloc?.stream.listen((kalaUserState) {
      if (kalaUserState is AuthenticatedKalaUserState) {
        getContentList();
      }
    });
  }

  Future<void> getContentList() async {
    emit(GallerySlideState.fakeGalleryState());
  }
}
