import 'dart:developer';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/gallery/content/models/content.dart';

void main() {
  test(
    'Test to add new content to Kala gallery',
    () async {
      final kalaUserContentCubit = KalaUserContentBloc.mock();
      final image = File('test_data/content/test_image.jpg');
      await kalaUserContentCubit.editNewContent(ContentProps.image, image);
      await kalaUserContentCubit.editNewContent(
        ContentProps.title,
        'test_title',
      );
      await kalaUserContentCubit.editNewContent(ContentProps.price, 100);
    
      await kalaUserContentCubit.addNewContent();
      log(FirebaseMocks.mockFirestore.dump());
      await kalaUserContentCubit.getUserContent(2);

      expect(kalaUserContentCubit.state.userContent?.length, 1);
    },
  );
}
