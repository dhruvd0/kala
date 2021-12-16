import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class KalaUser {
  final String name;
  final String id;

  /// Authentication Method
  /// Can be: "google", "phone", "instagram" or "email"
  final String authType;

  /// Profile image ulr
  final String? photoURL;

  final String contactURL;
  KalaUser({
    required this.name,
    required this.id,
    required this.authType,
    required this.photoURL,
    required this.contactURL,
  });
  factory KalaUser.fromSocialAuthUser(
    User user,
    String authType,
    String contact,
  ) {
    return KalaUser(
      name: user.displayName.toString(),
      id: user.uid.toString(),
      authType: authType,
      photoURL: user.photoURL ?? "",
      contactURL: contact,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'authType': authType,
      'photoURL': photoURL,
      'contactURL': contactURL,
    };
  }

  factory KalaUser.fromMap(Map<String, dynamic> map) {
    return KalaUser(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      authType: map['authType'] ?? '',
      photoURL: map['photoURL'],
      contactURL: map['contactURL'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory KalaUser.fromJson(String source) =>
      KalaUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'KalaUser(name: $name, id: $id, authType: $authType, photoURL: $photoURL, contactURL: $contactURL)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KalaUser &&
        other.name == name &&
        other.id == id &&
        other.authType == authType &&
        other.photoURL == photoURL &&
        other.contactURL == contactURL;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        authType.hashCode ^
        photoURL.hashCode ^
        contactURL.hashCode;
  }

  KalaUser copyWith({
    String? name,
    String? id,
    String? authType,
    String? photoURL,
    String? contactURL,
  }) {
    return KalaUser(
      name: name ?? this.name,
      id: id ?? this.id,
      authType: authType ?? this.authType,
      photoURL: photoURL ?? this.photoURL,
      contactURL: contactURL ?? this.contactURL,
    );
  }

  bool validateUser() {
    if (name.isEmpty || id.isEmpty || authType.isEmpty || contactURL.isEmpty) {
      return false;
    }
    return true;
  }
}
