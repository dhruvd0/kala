import 'package:kala/common/models/art.dart';

class ArtCardKey {
  static String key(ArtViewMode mode, String docID) {
    return '$mode-$docID';
  }
}
