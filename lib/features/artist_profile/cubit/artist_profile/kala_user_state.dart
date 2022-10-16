// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:kala/common/models/kala_user.dart';

abstract class KalaUserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialKalaUserState extends KalaUserState {}

class FetchedKalaUserState extends KalaUserState {
  final KalaUser kalaUser;
  FetchedKalaUserState(this.kalaUser);
}

class KalaUserLoadingState extends KalaUserState {}

class KalaUserErrorState extends KalaUserState {
  final String message;
  KalaUserErrorState(this.message);
}

class RegisteringState extends KalaUserLoadingState {}

class UserNotFoundState extends KalaUserState {}

extension StateTypeCasts on KalaUserState {
  FetchedKalaUserState get fetchedKalaUser => this as FetchedKalaUserState;
}
