
import 'package:kala/auth/models/kala_user.dart';

abstract class KalaUserState {
  final KalaUser kalaUser;
  KalaUserState({
    required this.kalaUser,
  });

  @override
  String toString() => 'KalaUserState(kalaUser: $kalaUser)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KalaUserState && other.kalaUser == kalaUser;
  }

  Map<String, dynamic> toMap() {
    return kalaUser.toMap();
  }

  @override
  int get hashCode => kalaUser.hashCode;
}

class AuthenticatedKalaUserState extends KalaUserState {
  AuthenticatedKalaUserState(KalaUser user) : super(kalaUser: user);
}

class UnauthenticatedKalaUserState extends KalaUserState {
  UnauthenticatedKalaUserState(KalaUser user) : super(kalaUser: user);
}

class ActiveKalaUserState extends KalaUserState {
  ActiveKalaUserState(KalaUser user) : super(kalaUser: user);
}
