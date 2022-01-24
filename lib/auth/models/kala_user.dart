import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:kala/config/typedefs.dart';
import 'package:kala/main.dart';

enum KalaUserState {
  unauthenticated,
  active,
  authenticated,
}

class KalaUser extends Equatable {
  const KalaUser({
    required this.authType,
    required this.contactURL,
    required this.kalaUserState,
    required this.lastSignIn,
    required this.name,
    required this.photoURL,
    required this.uid,
    required this.userMapData,
  });

  factory KalaUser.fromJson(String source) =>
      KalaUser.fromMap(json.decode(source));

  factory KalaUser.fromMap(Map<String, dynamic> map) {
    return KalaUser(
      authType: map['authType'] ?? '',
      contactURL: map['contactURL'] ?? '',
      kalaUserState: firebaseConfig?.auth.currentUser == null
          ? KalaUserState.unauthenticated
          : KalaUserState.authenticated,
      lastSignIn: map['lastSignIn'],
      name: map['name'] ?? '',
      photoURL: map['photoURL'],
      userMapData: map,
      uid: map['uid'] ?? '',
    );
  }

  factory KalaUser.fromSocialAuthUser(
    User user, {
    String? authType,
  }) {
    return KalaUser(
      name: user.displayName.toString(),
      authType: authType.toString(),
      lastSignIn: Timestamp.now(),
      photoURL: user.photoURL ?? '',
      kalaUserState: KalaUserState.authenticated,
      uid: user.uid,
      userMapData: const {},
      contactURL: user.phoneNumber ?? user.email.toString(),
    );
  }

  /// Authentication Method
  /// Can be: "google", "phone", "instagram" or "email"
  final String authType;

  final String contactURL;
  final KalaUserState kalaUserState;
  final Timestamp? lastSignIn;
  final String name;

  /// Profile image ulr
  final String? photoURL;

  final String uid;
  final Json userMapData;

  @override
  List<dynamic> get props {
    return [
      authType,
      contactURL,
      kalaUserState,
      lastSignIn,
      name,
      photoURL,
      uid,
      userMapData,
    ];
  }

  @override
  String toString() {
    return 'KalaUser(authType: $authType, contactURL: $contactURL, kalaUserState: $kalaUserState, lastSignIn: $lastSignIn, name: $name, photoURL: $photoURL, uid: $uid)';
  }

  Map<String, dynamic> toMap() {
    return {
      'authType': authType,
      'contactURL': contactURL,
      'kalaUserState': kalaUserState,
      'lastSignIn': lastSignIn,
      'name': name,
      'photoURL': photoURL,
      'uid': uid,
    };
  }

  String toJson() => json.encode(toMap());

  KalaUser copyWith({
    String? authType,
    String? contactURL,
    KalaUserState? kalaUserState,
    Timestamp? lastSignIn,
    String? name,
    String? photoURL,
    String? uid,
    Json? userMapData,
  }) {
    return KalaUser(
      authType: authType ?? this.authType,
      contactURL: contactURL ?? this.contactURL,
      kalaUserState: kalaUserState ?? this.kalaUserState,
      lastSignIn: lastSignIn ?? this.lastSignIn,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
      uid: uid ?? this.uid,
      userMapData: userMapData ?? this.userMapData,
    );
  }

  bool validateUser() {
    if (name.isEmpty || authType.isEmpty || contactURL.isEmpty) {
      return false;
    }
    return true;
  }
}
