// ignore_for_file: avoid_dynamic_calls

import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';

@immutable
class KalaUserContentState {
  const KalaUserContentState({
    required this.userContent,
    required this.coverContent,
    required this.bio,
    this.lastFetchedTimestamp,
  });

  final String bio;
  final Content coverContent;
  final List<Content> userContent;
  final Timestamp? lastFetchedTimestamp;

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
    List<Content>? userContent,
    Content? coverContent,
    String? bio,
    Timestamp? lastFetchedTimestamp,
  }) {
    return KalaUserContentState(
      userContent: userContent ?? this.userContent,
      coverContent: coverContent ?? this.coverContent,
      bio: bio ?? this.bio,
    );
  }
}
