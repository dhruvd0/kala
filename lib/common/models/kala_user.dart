// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:kala/common/models/art.dart';

class KalaUser extends Equatable {
  const KalaUser({
    required this.authType,
    required this.bio,
    required this.contactURL,
    this.isEditMode = false,
    required this.lastSignIn,
    required this.name,
    required this.photoURL,
    required this.uid,
  });

  factory KalaUser.fromJson(String source) =>
      KalaUser.fromMap(json.decode(source) as Map<String, dynamic>);

  factory KalaUser.fromMap(Map<String, dynamic> map) {
    return KalaUser(
      authType: map['authType'] as String,
      contactURL: map['contactURL'] as String,
      lastSignIn: map['lastSignIn'] != null
          ? Timestamp.fromDate(DateTime.parse(map['lastSignIn']))
          : null,
      name: map['name'] as String,
      photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
      uid: map['uid'] as String,
      isEditMode: map['isEditMode'] as bool,
      bio: map['bio'] as String,
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
      bio: '',
      photoURL: user.photoURL ?? '',
      uid: user.uid,
      contactURL: user.phoneNumber ?? user.email.toString(),
    );
  }

  /// Authentication Method
  /// Can be: "google", "phone", "instagram" or "email"
  final String authType;

  final String bio;
  final String contactURL;
  final bool isEditMode;

  final Timestamp? lastSignIn;
  final String name;

  /// Profile image ulr
  final String? photoURL;

  final String uid;

  @override
  List<dynamic> get props {
    return [
      authType,
      contactURL,
      lastSignIn,
      name,
      photoURL,
      uid,
      isEditMode,
      bio,
    ];
  }

  @override
  bool get stringify => true;

  dynamic get coverArt => null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'authType': authType,
      'contactURL': contactURL,
      'lastSignIn': lastSignIn?.toDate().toIso8601String(),
      'name': name,
      'photoURL': photoURL,
      'uid': uid,
      'isEditMode': isEditMode,
      'bio': bio,
    };
  }

  String toJson() => json.encode(toMap());

  KalaUser copyWith({
    List<Art>? userArt,
    String? authType,
    String? bio,
    String? contactURL,
    bool? isEditMode,
    Timestamp? lastSignIn,
    String? name,
    String? photoURL,
    String? uid,
  }) {
    return KalaUser(
      authType: authType ?? this.authType,
      bio: bio ?? this.bio,
      contactURL: contactURL ?? this.contactURL,
      isEditMode: isEditMode ?? this.isEditMode,
      lastSignIn: lastSignIn ?? this.lastSignIn,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
      uid: uid ?? this.uid,
    );
  }

  bool validateUser() {
    if (name.isEmpty || authType.isEmpty || contactURL.isEmpty) {
      return false;
    }
    return true;
  }

  bool isArtImageUrlValid() {
    return false;
  }
}
