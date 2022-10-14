import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/features/artist_content/upload_art/bloc/upload_art_bloc.dart';
import 'package:kala/features/artist_content/upload_art/bloc/upload_art_state.dart';

import '../../services_mocks.dart';

void main() {
  setUp(() async {
    setupBasicMockServices();
  });

  tearDown(() {
    getIt.reset();
  });



  blocTest<UploadArtBloc, UploadArtState>(
    'emits [MyState] when MyEvent is added.',
    build: () => UploadArtBloc(),
    act: (bloc) => bloc.add(MyEvent),
    expect: () => const <UploadArtState>[MyState],
  );
}

