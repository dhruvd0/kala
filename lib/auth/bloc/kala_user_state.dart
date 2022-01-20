
import 'package:flutter/cupertino.dart';
import 'package:kala/auth/models/kala_user.dart';
@immutable
abstract class KalaUserState {
  const KalaUserState({
    required this.kalaUser,
    required this.isEditMode,
  });

  final bool isEditMode;
  final KalaUser kalaUser;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is KalaUserState &&
        other.kalaUser == kalaUser &&
        other.isEditMode == isEditMode;
  }

  @override
  int get hashCode => kalaUser.hashCode ^ isEditMode.hashCode;

  @override
  String toString() =>
      'KalaUserState(kalaUser: $kalaUser, isEditMode: $isEditMode)';

  Map<String, dynamic> toMap() {
    return kalaUser.toMap();
  }
}

class AuthenticatedKalaUserState extends KalaUserState {
  const AuthenticatedKalaUserState(KalaUser user, {bool? editMode})
      : super(isEditMode: editMode ?? false, kalaUser: user);
}

class UnauthenticatedKalaUserState extends KalaUserState {
  const UnauthenticatedKalaUserState(KalaUser user, {bool? editMode})
      : super(isEditMode: editMode ?? false, kalaUser: user);
}

class ActiveKalaUserState extends KalaUserState {
  const ActiveKalaUserState(KalaUser user, {bool? editMode})
      : super(isEditMode: editMode ?? false, kalaUser: user);
}
