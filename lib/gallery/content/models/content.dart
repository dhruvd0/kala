import 'dart:convert';


class Content {
  final String imageUrl;
  final String artistName;
  final String artistID;
  final String title;
  final String description;
  final String contentID;
  Content({
    required this.imageUrl,
    required this.artistName,
    required this.artistID,
    required this.title,
    required this.description,
    required this.contentID,
  });

  Content copyWith({
    String? imageUrl,
    String? artistName,
    String? artistID,
    String? title,
    String? description,
    String? contentID,
  }) {
    return Content(
      imageUrl: imageUrl ?? this.imageUrl,
      artistName: artistName ?? this.artistName,
      artistID: artistID ?? this.artistID,
      title: title ?? this.title,
      description: description ?? this.description,
      contentID: contentID ?? this.contentID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'artistName': artistName,
      'artistID': artistID,
      'title': title,
      'description': description,
      'contentID': contentID,
    };
  }

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      imageUrl: map['imageUrl'] ?? '',
      artistName: map['artistName'] ?? '',
      artistID: map['artistID'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      contentID: map['contentID'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Content.fromJson(String source) =>
      Content.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Content(imageUrl: $imageUrl, artistName: $artistName, artistID: $artistID, title: $title, description: $description, contentID: $contentID)';
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
        other.contentID == contentID;
  }

  @override
  int get hashCode {
    return imageUrl.hashCode ^
        artistName.hashCode ^
        artistID.hashCode ^
        title.hashCode ^
        description.hashCode ^
        contentID.hashCode;
  }

  
}
