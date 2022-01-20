import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

// ignore_for_file: implicit_dynamic_map_literal
// ignore_for_file: argument_type_not_assignable
@immutable
class KalaUser {
  const KalaUser({
    required this.name,
    required this.authType,
    required this.photoURL,
    required this.contactURL,
    required this.lastSignIn,
  });

  factory KalaUser.fromJson(String source) =>
      KalaUser.fromMap(json.decode(source));

  factory KalaUser.fromMap(Map<String, dynamic> map) {
    return KalaUser(
      name: map['name'] ?? '',
      authType: map['authType'] ?? '',
      photoURL: map['photoURL'] ?? '',
      contactURL: map['contactURL'] ?? '',
      lastSignIn: map['lastSignIn'],
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
      contactURL: user.phoneNumber ?? user.email.toString(),
    );
  }

  /// Authentication Method
  /// Can be: "google", "phone", "instagram" or "email"
  final String authType;

  final String contactURL;
  final Timestamp? lastSignIn;
  final String name;
  /// Profile image ulr
  final String? photoURL;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is KalaUser &&
        other.name == name &&
        other.authType == authType &&
        other.photoURL == photoURL &&
        other.contactURL == contactURL &&
        other.lastSignIn == lastSignIn;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        authType.hashCode ^
        photoURL.hashCode ^
        contactURL.hashCode ^
        lastSignIn.hashCode;
  }

  @override
  String toString() {
    return 'KalaUser(name: $name, authType: $authType, photoURL: $photoURL, contactURL: $contactURL, lastSignIn: $lastSignIn)';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'authType': authType,
      'photoURL': photoURL,
      'contactURL': contactURL,
      'lastSignIn': lastSignIn
    };
  }

  String toJson() => json.encode(toMap());

  KalaUser copyWith({
    String? name,
    String? authType,
    String? photoURL,
    String? contactURL,
    Timestamp? lastSignIn,
  }) {
    return KalaUser(
      name: name ?? this.name,
      authType: authType ?? this.authType,
      photoURL: photoURL ?? this.photoURL,
      contactURL: contactURL ?? this.contactURL,
      lastSignIn: lastSignIn ?? this.lastSignIn,
    );
  }

  bool validateUser() {
    if (name.isEmpty || authType.isEmpty || contactURL.isEmpty) {
      return false;
    }
    return true;
  }
}
