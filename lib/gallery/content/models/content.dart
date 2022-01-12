import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Content {
  final String imageUrl;
  final String artistName;
  final String artistID;
  final String title;
  final String description;
  final String docID;
  final Timestamp uploadTimestamp;
  final int fileSize; // in kb
  final double imgHeight;
  final double imgWidth;
  Content({
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

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      imageUrl: map['imageUrl'] ?? '',
      artistName: map['artistName'] ?? '',
      artistID: map['artistID'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      docID: map['docID'] ?? '',
      uploadTimestamp: (map['uploadTimestamp']),
      fileSize: map['fileSize']?.toInt() ?? 0,
      imgHeight: map['imgHeight']?.toDouble() ?? 0.0,
      imgWidth: map['imgWidth']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Content.fromJson(String source) =>
      Content.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Content(imageUrl: $imageUrl, artistName: $artistName, artistID: $artistID, title: $title, description: $description, docID: $docID, uploadTimestamp: $uploadTimestamp, fileSize: $fileSize, imgHeight: $imgHeight, imgWidth: $imgWidth)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
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
}
