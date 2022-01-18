import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:kala/dashboard/bloc/dash_state.dart';

class DashController extends Cubit<DashState> {
  DashController()
      : super(
          DashState(
            pageController: PageController(),
            pageIndex: 0,
          ),
        );
  void nextPage() async {
    if (state.pageController.hasClients) {
      await state.pageController.nextPage(
        duration: const Duration(seconds: 200),
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
    if (state.pageController.hasClients) {
      await state.pageController.previousPage(
        duration: const Duration(seconds: 200),
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
