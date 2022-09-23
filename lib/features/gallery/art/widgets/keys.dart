import 'package:kala/features/gallery/art/models/art.dart';

class ArtCardKey {
  static String key(ArtViewMode mode, String docID) {
    return '$mode-$docID';
  }
}
