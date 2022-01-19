import 'dart:convert';

import 'package:kala/auth/models/kala_user.dart';

abstract class KalaUserState {
  final KalaUser kalaUser;
  final bool isEditMode;
  KalaUserState({
    required this.kalaUser,
    required this.isEditMode,
  });


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KalaUserState &&
        other.kalaUser == kalaUser &&
        other.isEditMode == isEditMode;
  }

  Map<String, dynamic> toMap() {
    return kalaUser.toMap();
  }

  @override
  int get hashCode => kalaUser.hashCode ^ isEditMode.hashCode;

  @override
  String toString() =>
      'KalaUserState(kalaUser: $kalaUser, isEditMode: $isEditMode)';
}

class AuthenticatedKalaUserState extends KalaUserState {
  AuthenticatedKalaUserState(KalaUser user, {bool? editMode})
      : super(isEditMode: editMode ?? false, kalaUser: user);
}

class UnauthenticatedKalaUserState extends KalaUserState {
  UnauthenticatedKalaUserState(KalaUser user, {bool? editMode})
      : super(isEditMode: editMode ?? false, kalaUser: user);
}

class ActiveKalaUserState extends KalaUserState {
  ActiveKalaUserState(KalaUser user, {bool? editMode})
      : super(isEditMode: editMode ?? false, kalaUser: user);
}
