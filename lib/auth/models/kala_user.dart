import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class KalaUser {
  final String name;
  final String id;
  final String authType;
  final String? photo_url;
  KalaUser({
    required this.name,
    required this.id,
    required this.authType,
    required this.photo_url,
  });
  factory KalaUser.fromSocialAuthUser(
    User user,
    String authType,
  ) {
    return KalaUser(
      name: user.displayName.toString(),
      id: user.uid.toString(),
      authType: authType,
      photo_url: user.photoURL??""
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'authType': authType,
      'photo_url': photo_url.toString(),
    };
  }

  factory KalaUser.fromMap(Map<String, dynamic> map) {
    return KalaUser(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      authType: map['authType'] ?? '',
      photo_url: map['photo_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory KalaUser.fromJson(String source) =>
      KalaUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'KalaUser(name: $name, id: $id, authType: $authType, photo_url: $photo_url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is KalaUser &&
      other.name == name &&
      other.id == id &&
      other.authType == authType &&
      other.photo_url == photo_url;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      id.hashCode ^
      authType.hashCode ^
      photo_url.hashCode;
  }

  KalaUser copyWith({
    String? name,
    String? id,
    String? authType,
    String? photo_url,
  }) {
    return KalaUser(
      name: name ?? this.name,
      id: id ?? this.id,
      authType: authType ?? this.authType,
      photo_url: photo_url ?? this.photo_url,
    );
  }
}
