// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:kala/common/models/art.dart';

abstract class UploadArtState {}

class UploadArtInitial extends UploadArtState {
  UploadArtInitial(this.art);

  final Art art;
}

class EditArtState extends UploadArtState {
  EditArtState(this.art);

  final Art art;

  EditArtState copyWith({
    Art? art,
  }) {
    return EditArtState(
      art ?? this.art,
    );
  }
}
