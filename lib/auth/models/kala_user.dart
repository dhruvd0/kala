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
  KalaUser({
    required this.name,
    required this.id,
    required this.authType,
    required this.photoURL,
  });
  factory KalaUser.fromSocialAuthUser(
    User user,
    String authType,
  ) {
    return KalaUser(
      name: user.displayName.toString(),
      id: user.uid.toString(),
      authType: authType,
      photoURL: user.photoURL??""
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'authType': authType,
      'photoURL': photoURL,
    };
  }

  factory KalaUser.fromMap(Map<String, dynamic> map) {
    return KalaUser(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      authType: map['authType'] ?? '',
      photoURL: map['photoURL'],
    );
  }

  String toJson() => json.encode(toMap());

  factory KalaUser.fromJson(String source) =>
      KalaUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'KalaUser(name: $name, id: $id, authType: $authType, photoURL: $photoURL)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is KalaUser &&
      other.name == name &&
      other.id == id &&
      other.authType == authType &&
      other.photoURL == photoURL;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      id.hashCode ^
      authType.hashCode ^
      photoURL.hashCode;
  }

  KalaUser copyWith({
    String? name,
    String? id,
    String? authType,
    String? photoURL,
  }) {
    return KalaUser(
      name: name ?? this.name,
      id: id ?? this.id,
      authType: authType ?? this.authType,
      photoURL: photoURL ?? this.photoURL,
    );
  }
}
