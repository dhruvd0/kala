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
    required this.userContent,
    required this.uid,
    this.lastFetchedTimestamp,
  }) : assert(coverContent is File || coverContent is String);

  final String bio;
  final dynamic coverContent;
  final Timestamp? lastFetchedTimestamp;
  final Content newContent;
  final String uid;
  final List<Content> userContent;

  @override
  List<dynamic> get props {
    return [
      bio,
      coverContent,
      lastFetchedTimestamp,
      newContent,
      userContent,
      uid,
    ];
  }

  @override
  String toString() {
    return 'KalaUserContentState(bio: $bio, coverContent: $coverContent, lastFetchedTimestamp: $lastFetchedTimestamp, newContent: $newContent, userContent: $userContent, uid: $uid)';
  }

  KalaUserContentState copyWith({
    String? bio,
    dynamic coverContent,
    Timestamp? lastFetchedTimestamp,
    Content? newContent,
    List<Content>? userContent,
    String? uid,
  }) {
    return KalaUserContentState(
      bio: bio ?? this.bio,
      coverContent: coverContent ?? this.coverContent,
      lastFetchedTimestamp: lastFetchedTimestamp ?? this.lastFetchedTimestamp,
      newContent: newContent ?? this.newContent,
      userContent: userContent ?? this.userContent,
      uid: uid ?? this.uid,
    );
  }
}
