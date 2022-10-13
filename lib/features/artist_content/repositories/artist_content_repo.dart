import 'package:kala/common/models/art.dart';
import 'package:kala/features/artist_content/services/artist_content_service.dart';

class ArtistContentRepository {
  ArtistContentRepository(this.artistContentService);

  final ArtistContentService artistContentService;
  Future<List<Art>> getUserArt(int scrollPosition) async {
    return (await artistContentService.getUserArt(scrollPosition))
        .map((e) => Art.fromMap(e))
        .toList();
  }
}
