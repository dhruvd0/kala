import 'package:bloc/bloc.dart';
import 'package:kala/common/models/art.dart';

class ArtBloc extends Cubit<Art> {
  ArtBloc(Art initialState) : super(initialState);
}
