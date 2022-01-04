import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KalaUser {
  final String name;

  /// Authentication Method
  /// Can be: "google", "phone", "instagram" or "email"
  final String authType;

  /// Profile image ulr
  final String? photoURL;

  final String contactURL;
  final Timestamp? lastSignIn;
  KalaUser({
    required this.name,
    required this.authType,
    required this.photoURL,
    required this.contactURL,
    required this.lastSignIn,
  });
  factory KalaUser.fromSocialAuthUser(
    User user, {
    String? authType,
  }) {
    return KalaUser(
      name: user.displayName.toString(),
      authType: authType.toString(),
      lastSignIn: Timestamp.now(),
      photoURL: user.photoURL ?? "",
      contactURL: user.phoneNumber ?? user.email.toString(),
    );
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

  factory KalaUser.fromMap(Map<String, dynamic> map) {
    return KalaUser(
      name: map['name'] ?? '',
      authType: map['authType'] ?? '',
      photoURL: map['photoURL'] ?? "",
      contactURL: map['contactURL'] ?? '',
      lastSignIn: ((map['lastSignIn'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory KalaUser.fromJson(String source) =>
      KalaUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'KalaUser(name: $name, authType: $authType, photoURL: $photoURL, contactURL: $contactURL, lastSignIn: $lastSignIn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

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
