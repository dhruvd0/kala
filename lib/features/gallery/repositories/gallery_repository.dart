import 'package:kala/features/gallery/art/models/art.dart';
import 'package:kala/features/gallery/services/gallery_service.dart';

class GalleryRepository {
  GalleryRepository(this.galleryService);

  final GalleryService galleryService;
  Future<List<Art>> getGalleryArt(
    int scrollPosition,
  ) async {
    return (await galleryService.getGalleryArt(
      scrollPosition,
    ))
        .map((e) => Art.fromMap(e))
        .toList();
  }
}
