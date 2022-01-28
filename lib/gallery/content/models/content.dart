import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

enum ContentViewMode { scroll, grid }

// ignore_for_file: implicit_dynamic_map_literal
// ignore_for_file: argument_type_not_assignable

@immutable
class Content extends Equatable {
  const Content({
    required this.artistID,
    required this.artistName,
    required this.description,
    required this.docID,
    required this.fileSize,
    required this.imageUrl,
    required this.imgHeight,
    required this.imgWidth,
    required this.price,
    required this.title,
    required this.uploadTimestamp,
    required this.viewMode,
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
      imageUrl: map['imageUrl'],
      imgHeight: map['imgHeight']?.toDouble() ?? 0.0,
      imgWidth: map['imgWidth']?.toDouble() ?? 0.0,
      price: map['price']?.toInt() ?? 0,
      title: map['title'] ?? '',
      uploadTimestamp: map['uploadTimestamp'],
      viewMode: (map['viewMode']) ?? ContentViewMode.scroll,
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
  final ContentViewMode viewMode;

  @override
  List<dynamic> get props {
    return [
      artistID,
      artistName,
      description,
      docID,
      fileSize,
      imageFile,
      imageUrl,
      imgHeight,
      imgWidth,
      price,
      title,
      uploadTimestamp,
      viewMode,
    ];
  }

  @override
  String toString() {
    return 'Content(artistID: $artistID, artistName: $artistName, description: $description, docID: $docID, fileSize: $fileSize, imageFile: $imageFile, imageUrl: $imageUrl, imgHeight: $imgHeight, imgWidth: $imgWidth, price: $price, title: $title, uploadTimestamp: $uploadTimestamp, viewMode: $viewMode)';
  }

  Content copyWith({
    String? artistID,
    String? artistName,
    String? description,
    String? docID,
    int? fileSize,
    File? imageFile,
    String? imageUrl,
    double? imgHeight,
    double? imgWidth,
    int? price,
    String? title,
    Timestamp? uploadTimestamp,
    ContentViewMode? viewMode,
  }) {
    return Content(
      artistID: artistID ?? this.artistID,
      artistName: artistName ?? this.artistName,
      description: description ?? this.description,
      docID: docID ?? this.docID,
      fileSize: fileSize ?? this.fileSize,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      imgHeight: imgHeight ?? this.imgHeight,
      imgWidth: imgWidth ?? this.imgWidth,
      price: price ?? this.price,
      title: title ?? this.title,
      uploadTimestamp: uploadTimestamp ?? this.uploadTimestamp,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'artistID': artistID,
      'artistName': artistName,
      'description': description,
      'docID': docID,
      'fileSize': fileSize,
      'imageUrl': imageUrl,
      'imgHeight': imgHeight,
      'imgWidth': imgWidth,
      'price': price,
      'title': title,
      'uploadTimestamp': uploadTimestamp,
    };
  }

  String toJson() => json.encode(toMap());

  bool isValid() {
    try {
      assert(title.isNotEmpty);
      assert(artistID.isNotEmpty);
      assert(artistName.isNotEmpty);
      assert(uploadTimestamp != null);
      assert(uploadTimestamp!.toDate().year >= 2022);
      assert(docID.isNotEmpty);
      assert(fileSize > 1);
      assert(imgHeight > 1);
      assert(imgWidth > 1);
      assert(imageUrl?.isNotEmpty ?? false);

      return true;
      // ignore: avoid_catching_errors
    } on AssertionError catch (e) {
      log(e.toString());
      return false;
    }
  }
}

enum ContentProps {
  title,
  price,
  image,
  description,
}
