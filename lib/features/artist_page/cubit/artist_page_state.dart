part of 'artist_page_cubit.dart';

abstract class ArtistPageState extends Equatable {
  ArtistPageState();
  final List<Art> userArt = [];

  @override
  List<Object> get props => [];
}

class ArtistPageInitial extends ArtistPageState {}
