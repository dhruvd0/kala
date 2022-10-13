import 'package:kala/common/models/art.dart';
import 'package:kala/common/utils/helper_bloc/content_pagination/pagination_bloc.dart';
import 'package:kala/common/utils/helper_bloc/content_pagination/pagination_state.dart';

class ArtistContentService {
  ArtistContentService(this.artistID) {
    paginationCubit = PaginationCubit.userArtPagination(artistID);
  }
  final String artistID;
  late PaginationCubit<Art> paginationCubit;
  Future<List<Map<String, dynamic>>> getUserArt(
    int scrollPosition,
  ) async {
    final userArtJson = await paginationCubit.getJsonList(
      scrollPosition,
      segment: scrollPosition == 0
          ? CollectionSegment.initial
          : CollectionSegment.next,
    );

    return userArtJson;
  }
}
