import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

// ignore_for_file: implicit_dynamic_map_literal
// ignore_for_file: argument_type_not_assignable
@immutable
class Content {
  const Content({
    required this.artistID,
    required this.artistName,
    required this.description,
    required this.docID,
    required this.fileSize,
    required this.price,
    required this.imageUrl,
    required this.imgHeight,
    required this.imgWidth,
    required this.title,
    required this.uploadTimestamp,
    this.imageFile,
  });

  factory Content.fromJson(String source) =>
      Content.fromMap(json.decode(source));

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      artistID: map['artistID'] ?? '',
      artistName: map['artistName'] ?? '',
      description: map['description'] ?? '',
      docID: map['docID'] ?? '',
      fileSize: map['fileSize']?.toInt() ?? 0,
      price: map['price']?.toInt() ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      imgHeight: map['imgHeight']?.toDouble() ?? 0.0,
      imgWidth: map['imgWidth']?.toDouble() ?? 0.0,
      title: map['title'] ?? '',
      uploadTimestamp: (map['uploadTimestamp']),
    );
  }

  final String artistID;
  final String artistName;
  final String description;
  final String docID;
  final int fileSize; // in kb
  final File? imageFile;
  final String? imageUrl;
  final double imgHeight;
  final double imgWidth;
  final int price;
  final String title;
  final Timestamp? uploadTimestamp;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Content &&
        other.artistID == artistID &&
        other.artistName == artistName &&
        other.description == description &&
        other.docID == docID &&
        other.fileSize == fileSize &&
        other.price == price &&
        other.imageUrl == imageUrl &&
        other.imgHeight == imgHeight &&
        other.imgWidth == imgWidth &&
        other.title == title &&
        other.uploadTimestamp == uploadTimestamp;
  }

  @override
  int get hashCode {
    return artistID.hashCode ^
        artistName.hashCode ^
        description.hashCode ^
        docID.hashCode ^
        fileSize.hashCode ^
        price.hashCode ^
        imageUrl.hashCode ^
        imgHeight.hashCode ^
        imgWidth.hashCode ^
        title.hashCode ^
        uploadTimestamp.hashCode;
  }

  @override
  String toString() {
    return 'Content(artistID: $artistID, artistName: $artistName, description: $description, docID: $docID, fileSize: $fileSize, price: $price, imageUrl: $imageUrl, imgHeight: $imgHeight, imgWidth: $imgWidth, title: $title, uploadTimestamp: $uploadTimestamp)';
  }

  Content copyWith({
    String? artistID,
    String? artistName,
    String? description,
    String? docID,
    int? fileSize,
    int? price,
    File? imageFile,
    String? imageUrl,
    double? imgHeight,
    double? imgWidth,
    String? title,
    Timestamp? uploadTimestamp,
  }) {
    return Content(
      artistID: artistID ?? this.artistID,
      artistName: artistName ?? this.artistName,
      description: description ?? this.description,
      docID: docID ?? this.docID,
      fileSize: fileSize ?? this.fileSize,
      price: price ?? this.price,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      imgHeight: imgHeight ?? this.imgHeight,
      imgWidth: imgWidth ?? this.imgWidth,
      title: title ?? this.title,
      uploadTimestamp: uploadTimestamp ?? this.uploadTimestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'artistID': artistID,
      'artistName': artistName,
      'description': description,
      'docID': docID,
      'fileSize': fileSize,
      'price': price,
      'imageUrl': imageUrl,
      'imgHeight': imgHeight,
      'imgWidth': imgWidth,
      'title': title,
      'uploadTimestamp': uploadTimestamp,
    };
  }

  String toJson() => json.encode(toMap());

  void validate() {
    assert(title.isNotEmpty);
    assert(artistID.isNotEmpty);
    assert(artistName.isNotEmpty);
    assert(imageFile != null);
    assert(fileSize > 0);
  }
}

enum ContentProps {
  title,
  price,
  image,
  description,
}
