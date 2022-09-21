import 'package:bloc/bloc.dart';
import 'package:kala/features/gallery/content/models/content.dart';

class ContentBloc extends Cubit<Content> {
  ContentBloc(Content initialState) : super(initialState);
}
