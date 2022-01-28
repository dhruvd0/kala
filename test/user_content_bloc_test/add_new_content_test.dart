import 'dart:developer';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kala/artist_page/add_new_content/bloc/add_new_content_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/gallery/content/models/content.dart';

void main() {
  test(
    'Test to add new content to Kala gallery',
    () async {
      await addNewMockContent();
      log(FirebaseMocks.mockFirestore.dump());
      final kalaUserContentCubit = KalaUserContentBloc.mock()
        ..toggleEditMode(forceToggle: false);

      await kalaUserContentCubit.getUserContent(2);

      expect(kalaUserContentCubit.state.userContent?.length, 1);
      expect(kalaUserContentCubit.state.userContent!.first.isValid(), true);
    },
  );
}

Future<void> addNewMockContent() async {
  final addNewContentCubit = AddNewContentCubit.mock();
  final image = File('test_data/content/test_image.jpg');

  await addNewContentCubit.editNewContent(ContentProps.image, image);
  await addNewContentCubit.editNewContent(
    ContentProps.title,
    'test_title',
  );
  await addNewContentCubit.editNewContent(ContentProps.price, 100);

  await addNewContentCubit.addNewContent();
}
