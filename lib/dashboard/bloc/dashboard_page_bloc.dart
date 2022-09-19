import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'dashboard_page_event.dart';
part 'dashboard_page_state.dart';

class DashboardPageBloc extends Bloc<DashboardPageEvent, DashboardPageState> {
  DashboardPageBloc() : super(const DashboardPageInitial('0')) {
    on<NextPage>((event, emit) {
      emit(NextPageState());
    });
    on<PreviousPage>((event, emit) {
      emit(PreviousPageState());
    });
  }
}
