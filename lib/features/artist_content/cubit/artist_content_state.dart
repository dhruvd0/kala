// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'artist_content_cubit.dart';

abstract class ArtistContentState extends Equatable {
  const ArtistContentState();
}

class ArtistContentInitial extends ArtistContentState {
  const ArtistContentInitial();

  @override
  List<Object> get props => [];
}

class ArtistContentLoadingState extends ArtistContentState {
  const ArtistContentLoadingState();

  @override
  List<Object> get props => [];
}

class ArtistContentLoadedState extends ArtistContentState {
  final List<Art> userArt;
  final List<Art> acquiredArt;
  const ArtistContentLoadedState({
    required this.userArt,
    required this.acquiredArt,
  });
  @override
  List<Object> get props => [userArt, acquiredArt];

  ArtistContentLoadedState copyWith({
    List<Art>? userArt,
    List<Art>? acquiredArt,
  }) {
    return ArtistContentLoadedState(
      userArt: userArt ?? this.userArt,
      acquiredArt: acquiredArt ?? this.acquiredArt,
    );
  }
}
