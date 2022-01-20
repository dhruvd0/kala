// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';

@immutable
class KalaUserContentState {
  const KalaUserContentState({
    required this.userContent,
    required this.coverContent,
    required this.bio,
    required this.newContent,
    this.lastFetchedTimestamp,
  }) : assert(coverContent is File || coverContent is String);

  final String bio;
  final dynamic coverContent;
  final List<Content> userContent;
  final Timestamp? lastFetchedTimestamp;
  final Content newContent;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is KalaUserContentState &&
        listEquals(other.userContent, userContent) &&
        other.coverContent == coverContent &&
        other.bio == bio;
  }

  @override
  int get hashCode =>
      userContent.hashCode ^ coverContent.hashCode ^ bio.hashCode;

  @override
  String toString() =>
      'KalaUserContentState(userContent: $userContent, coverContent: $coverContent, bio: $bio)';

  KalaUserContentState copyWith({
    String? bio,
    dynamic? coverContent,
    List<Content>? userContent,
    Timestamp? lastFetchedTimestamp,
    Content? newContent,
  }) {
    return KalaUserContentState(
      bio: bio ?? this.bio,
      coverContent: coverContent ?? this.coverContent,
      userContent: userContent ?? this.userContent,
      lastFetchedTimestamp: lastFetchedTimestamp ?? this.lastFetchedTimestamp,
      newContent: newContent ?? this.newContent,
    );
  }
}
