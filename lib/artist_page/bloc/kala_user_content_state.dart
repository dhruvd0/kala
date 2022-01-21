// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:kala/gallery/content/models/content.dart';

@immutable
class KalaUserContentState extends Equatable {
  const KalaUserContentState({
    required this.userContent,
    required this.coverContent,
    required this.bio,
    required this.newContent,
    this.lastFetchedTimestamp,
  }) : assert(coverContent is File || coverContent is String);

  final String bio;
  final dynamic coverContent;
  final Timestamp? lastFetchedTimestamp;
  final Content newContent;
  final List<Content> userContent;

  @override
  List<Object> get props {
    return [
      bio,
      coverContent,
      lastFetchedTimestamp ?? Timestamp.now(),
      newContent,
      userContent,
    ];
  }

  @override
  String toString() =>
      'KalaUserContentState(userContent: $userContent, coverContent: $coverContent, bio: $bio)';

  KalaUserContentState copyWith({
    String? bio,
    dynamic coverContent,
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
