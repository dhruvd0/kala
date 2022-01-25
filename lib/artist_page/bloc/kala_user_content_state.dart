import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';

@immutable
class KalaUserContentState extends Equatable {
  const KalaUserContentState({
    required this.bio,
    required this.coverContent,
    required this.newContent,
    required this.uid,
    required this.isEditMode,
    this.lastFetchedTimestamp,
    this.userContent,
    this.coverContentUrl,
  }) : assert(coverContent is File || coverContent is String);

  factory KalaUserContentState.fromMap(Map<String, dynamic> map) {
    return KalaUserContentState(
      bio: map['bio'] ?? '',
      coverContent: map['coverContent'],
      coverContentUrl:
          map['coverContent'] is String ? map['coverContent'] : null,
      lastFetchedTimestamp: map['lastFetchedTimestamp'],
      newContent: Content.fromMap(const {}),
      uid: map['uid'] ?? '',
      userContent: const [],
      isEditMode: map['isEditMode'] ?? false,
    );
  }

  final String bio;
  final dynamic coverContent;
  final String? coverContentUrl;
  final bool isEditMode;
  final Timestamp? lastFetchedTimestamp;
  final Content newContent;
  final String uid;
  final List<Content>? userContent;

  @override
  List<dynamic> get props {
    return [
      bio,
      coverContent,
      isEditMode,
      lastFetchedTimestamp,
      newContent,
      uid,
      userContent,
    ];
  }

  @override
  String toString() {
    return 'KalaUserContentState(bio: $bio, coverContent: $coverContent, lastFetchedTimestamp: $lastFetchedTimestamp, newContent: $newContent, uid: $uid, userContent: $userContent, isEditMode: $isEditMode)';
  }

  bool isContentImageUrlValid() {
    return coverContent is String &&
        coverContent.toString().isNotEmpty &&
        coverContent.toString().contains('firebasestorage');
  }

  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'coverContent': coverContent,
      'lastFetchedTimestamp': lastFetchedTimestamp,
      'newContent': newContent.toMap(),
      'uid': uid,
      'isEditMode': isEditMode,
    };
  }

  String toJson() => json.encode(toMap());

  KalaUserContentState copyWith({
    String? bio,
    dynamic? coverContent,
    String? coverContentUrl,
    bool? isEditMode,
    Timestamp? lastFetchedTimestamp,
    Content? newContent,
    String? uid,
    List<Content>? userContent,
  }) {
    return KalaUserContentState(
      bio: bio ?? this.bio,
      coverContent: coverContent ?? this.coverContent,
      coverContentUrl: coverContentUrl ?? this.coverContentUrl,
      isEditMode: isEditMode ?? this.isEditMode,
      lastFetchedTimestamp: lastFetchedTimestamp ?? this.lastFetchedTimestamp,
      newContent: newContent ?? this.newContent,
      uid: uid ?? this.uid,
      userContent: userContent ?? this.userContent,
    );
  }
}
