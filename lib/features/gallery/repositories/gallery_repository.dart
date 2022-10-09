import 'package:kala/features/gallery/art/models/art.dart';
import 'package:kala/features/gallery/services/gallery_service.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

class GalleryRepository {
  GalleryRepository(this.galleryService);

  final GalleryService galleryService;
  Future<List<Art>> getGalleryArt(
    int scrollPosition, {
    required CollectionSegment segment,
  }) async {
    return (await galleryService.getGalleryArt(
      scrollPosition,
      segment: segment,
    ))
        .map((e) => Art.fromMap(e))
        .toList();
  }
}
