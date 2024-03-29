import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kala/common/models/art.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/features/artist_profile/repositories/artist_content_repo.dart';
import 'package:kala/features/artist_profile/services/artist_content_service.dart';

part 'artist_content_state.dart';

class ArtistContentCubit extends Cubit<ArtistContentState> {
  ArtistContentCubit(this.artistContentRepository)
      : super(const ArtistContentInitial());

  final ArtistContentRepository artistContentRepository;

  Future<void> getArtistArt([int scrollPosition = 0]) async {
    if (state is ArtistContentInitial) {
      emit(const ArtistContentLoadingState());
    }

    final newGalleryArt =
        await artistContentRepository.getUserArt(scrollPosition);
    if (state is ArtistContentLoadedState) {
      emit(
        (state as ArtistContentLoadedState).copyWith(
          userArt: scrollPosition == 0
              ? [
                  ...newGalleryArt,
                  ...(state as ArtistContentLoadedState).userArt,
                ]
              : [
                  ...(state as ArtistContentLoadedState).userArt,
                  ...newGalleryArt
                ],
        ),
      );
    } else {
      emit(
        ArtistContentLoadedState(
          userArt: newGalleryArt,
          acquiredArt: const [],
        ),
      );
    }
  }
}

/// Content cubit for the logged in artist
///
///
class AuthenticatedArtistContentCubit extends ArtistContentCubit {
  AuthenticatedArtistContentCubit()
      : super(
          ArtistContentRepository(
            ArtistContentService(firebaseConfig.auth.currentUser!.uid),
          ),
        );
}
