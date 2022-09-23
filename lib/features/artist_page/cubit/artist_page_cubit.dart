import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kala/features/gallery/art/models/art.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

part 'artist_page_state.dart';

class ArtistPageCubit extends Cubit<ArtistPageState> {
  ArtistPageCubit() : super(ArtistPageInitial());

  getUserArt(int i, {required CollectionSegment collectionSegment}) {}
}
