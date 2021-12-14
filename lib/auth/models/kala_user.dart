import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

enum AuthType {
  google,
  phone,
  facebook,
  instagram,
  anonymous,
}

class KalaUser {
  final String name;
  final String id;
  final AuthType authType;
  KalaUser({
    required this.name,
    required this.id,
    required this.authType,
  });
  factory KalaUser.fromSocialAuthUser(
    User user,
    AuthType authType,
  ) {
    return KalaUser(
      name: user.displayName.toString(),
      id: user.uid.toString(),
      authType: authType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'authType': authType,
    };
  }

  factory KalaUser.fromMap(Map<String, dynamic> map) {
    return KalaUser(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      authType: (map['authType']),
    );
  }

  String toJson() => json.encode(toMap());

  factory KalaUser.fromJson(String source) =>
      KalaUser.fromMap(json.decode(source));

  @override
  String toString() => 'KalaUser(name: $name, id: $id, authType: $authType)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KalaUser &&
        other.name == name &&
        other.id == id &&
        other.authType == authType;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ authType.hashCode;

  KalaUser copyWith({
    String? name,
    String? id,
    AuthType? authType,
  }) {
    return KalaUser(
      name: name ?? this.name,
      id: id ?? this.id,
      authType: authType ?? this.authType,
    );
  }
}
