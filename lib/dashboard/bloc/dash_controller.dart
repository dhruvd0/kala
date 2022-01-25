import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:kala/dashboard/bloc/dash_state.dart';
import 'package:preload_page_view/preload_page_view.dart';

class DashController extends Cubit<DashState> {
  DashController()
      : super(
          const DashState(
            pageIndex: 0,
          ),
        );

  static final PreloadPageController pageController =
      PreloadPageController(initialPage: 0);

  Future<void> nextPage() async {
    if (DashController.pageController.hasClients) {
      await pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );

      // emit(
      //   state.copyWith(
      //     pageIndex: state.pageIndex == DashState.pages.length - 1
      //         ? 0
      //         : state.pageIndex + 1,
      //   ),
      // );
    }
  }

  void setPageIndex(int index) {
    emit(state.copyWith(pageIndex: index));
  }

  Future<void> previousPage() async {
    if (pageController.hasClients) {
      await pageController.previousPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
      emit(
        state.copyWith(
          pageIndex: state.pageIndex == 0 ? 0 : state.pageIndex - 1,
        ),
      );
    }
  }
}
