import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:kala/dashboard/bloc/dash_state.dart';

class DashController extends Cubit<DashState> {
  static final PageController pageController = PageController();
  DashController()
      : super(
          DashState(
            pageIndex: 0,
          ),
        );
  void nextPage() async {
    if (pageController.hasClients) {
      await pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );

      emit(
        state.copyWith(
          pageIndex: state.pageIndex == state.pages.length - 1
              ? 0
              : state.pageIndex + 1,
        ),
      );
    }
  }

  void setPageIndex(int index) {
    emit(state.copyWith(pageIndex: index));
  }

  void previousPage() async {
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
