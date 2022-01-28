import 'package:kala/gallery/content/models/content.dart';

class ContentCardKey {
  static String key(ContentViewMode mode, String docID) {
    return '$mode-$docID';
  }
}
