import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

// ignore_for_file: implicit_dynamic_map_literal
// ignore_for_file: argument_type_not_assignable
@immutable
class Content  {
  const Content({
    required this.imageUrl,
    required this.artistName,
    required this.artistID,
    required this.title,
    required this.description,
    required this.docID,
    required this.uploadTimestamp,
    required this.fileSize,
    required this.imgHeight,
    required this.imgWidth,
  });

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      imageUrl: map['imageUrl'] ?? '',
      artistName: map['artistName'] ?? '',
      artistID: map['artistID'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      docID: map['docID'] ?? '',
      uploadTimestamp: map['uploadTimestamp']??Timestamp.fromMicrosecondsSinceEpoch(0),
      fileSize: map['fileSize'] ?? 0,
      imgHeight: map['imgHeight'] ?? 0.0,
      imgWidth: map['imgWidth'] ?? 0.0,
    );
  }

  final String artistID;
  final String artistName;
  final String description;
  final String docID;
  final int fileSize; // in kb
  final String imageUrl;
  final double imgHeight;
  final double imgWidth;
  final String title;
  final Timestamp uploadTimestamp;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Content &&
        other.imageUrl == imageUrl &&
        other.artistName == artistName &&
        other.artistID == artistID &&
        other.title == title &&
        other.description == description &&
        other.docID == docID &&
        other.uploadTimestamp == uploadTimestamp &&
        other.fileSize == fileSize &&
        other.imgHeight == imgHeight &&
        other.imgWidth == imgWidth;
  }

  @override
  int get hashCode {
    return imageUrl.hashCode ^
        artistName.hashCode ^
        artistID.hashCode ^
        title.hashCode ^
        description.hashCode ^
        docID.hashCode ^
        uploadTimestamp.hashCode ^
        fileSize.hashCode ^
        imgHeight.hashCode ^
        imgWidth.hashCode;
  }

  @override
  String toString() {
    return 'Content(imageUrl: $imageUrl, artistName: $artistName, artistID: $artistID, title: $title, description: $description, docID: $docID, uploadTimestamp: $uploadTimestamp, fileSize: $fileSize, imgHeight: $imgHeight, imgWidth: $imgWidth)';
  }

  Content copyWith({
    String? imageUrl,
    String? artistName,
    String? artistID,
    String? title,
    String? description,
    String? docID,
    Timestamp? uploadTimestamp,
    int? fileSize,
    double? imgHeight,
    double? imgWidth,
  }) {
    return Content(
      imageUrl: imageUrl ?? this.imageUrl,
      artistName: artistName ?? this.artistName,
      artistID: artistID ?? this.artistID,
      title: title ?? this.title,
      description: description ?? this.description,
      docID: docID ?? this.docID,
      uploadTimestamp: uploadTimestamp ?? this.uploadTimestamp,
      fileSize: fileSize ?? this.fileSize,
      imgHeight: imgHeight ?? this.imgHeight,
      imgWidth: imgWidth ?? this.imgWidth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'artistName': artistName,
      'artistID': artistID,
      'title': title,
      'description': description,
      'docID': docID,
      'uploadTimestamp': uploadTimestamp,
      'fileSize': fileSize,
      'imgHeight': imgHeight,
      'imgWidth': imgWidth,
    };
  }
}
