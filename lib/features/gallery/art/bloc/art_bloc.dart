import 'package:bloc/bloc.dart';
import 'package:kala/features/gallery/art/models/art.dart';

class ArtBloc extends Cubit<Art> {
  ArtBloc(Art initialState) : super(initialState);
}
