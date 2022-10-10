import 'package:kala/features/gallery/art/models/art.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_bloc.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

class GalleryService {
  final PaginationCubit<Art> paginationCubit =
      PaginationCubit.galleryArtPagination();
  Future<List<Map<String, dynamic>>> getGalleryArt(
    int scrollPosition,
  ) async {
    final galleryJson = await paginationCubit.getJsonList(
      scrollPosition,
      segment: scrollPosition == 0
          ? CollectionSegment.initial
          : CollectionSegment.next,
    );

    return galleryJson;
  }
}
