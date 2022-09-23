// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:kala/features/auth/models/kala_user.dart';

abstract class KalaUserState extends Equatable {
  final KalaUser kalaUser;
  const KalaUserState({
    required this.kalaUser,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [kalaUser];
}

class InitialKalaUserState extends KalaUserState {
  const InitialKalaUserState()
      : super(
          kalaUser: const KalaUser(
            name: '',
            authType: '',
            photoURL: '',
            contactURL: '',
            lastSignIn: null,
            uid: '',
            bio: '',
          ),
        );
}

class AuthenticatedKalaUserState extends KalaUserState {
  const AuthenticatedKalaUserState({required KalaUser kalaUser})
      : super(kalaUser: kalaUser);
}

class KalaUserLoadingState extends KalaUserState {
  KalaUserLoadingState()
      : super(kalaUser: const InitialKalaUserState().kalaUser);
}
class KalaUserErrorState extends KalaUserState {
  final String message;
  KalaUserErrorState(this.message)
      : super(kalaUser: const InitialKalaUserState().kalaUser);
}
