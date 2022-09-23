part of 'artist_page_cubit.dart';

abstract class ArtistPageState extends Equatable {
  final List<Art> userArt = [];

  ArtistPageState();

  @override
  List<Object> get props => [];
}

class ArtistPageInitial extends ArtistPageState {}
