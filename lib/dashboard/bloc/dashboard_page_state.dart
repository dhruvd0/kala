part of 'dashboard_page_bloc.dart';

abstract class DashboardPageState extends Equatable {
  const DashboardPageState(this.id);
  final String id;
  @override
  List<Object> get props => [];
}

class DashboardPageInitial extends DashboardPageState {
  const DashboardPageInitial(String id) : super(id);
}

class NextPageState extends DashboardPageState {
  NextPageState() : super(UniqueKey().toString());
}

class PreviousPageState extends DashboardPageState {
  PreviousPageState() : super(UniqueKey().toString());
}
