import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/gallery/bloc/gallery_slide_state.dart';
import 'package:kala/main.dart';

class GalleryBloc extends Cubit<GalleryState> {
  StreamSubscription<KalaUserState>? kalaUserStateStream;
  GalleryBloc({KalaUserBloc? kalaUserBloc})
      : super(GalleryState(
          contentSlideList: [],
        )) {
    kalaUserStateStream= kalaUserBloc?.stream.listen((state) {
      if (state is AuthenticatedKalaUserState) {
        getContentList();
      }
    });
  }
  @override
  Future<void> close() async {
    await kalaUserStateStream?.cancel();
    return super.close();
  }

  Future<void> getContentList() async {
    if (TEST_FLAG) {
      emit(GalleryState.fakeGalleryState());
    } else {
      emit(GalleryState.fakeGalleryState());
    }
  }
}
