import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';

int length = 10;
void main() {
  test('Test to get initial user content for artist page', () async {
    final userContentBloc = await userContentBlocSetup();
    await userContentBloc.getUserContent(1);
    expect(userContentBloc.state.userContent.isNotEmpty, true);
    expect(userContentBloc.state.userContent.first.docID, '${length - 1}');
    expect(userContentBloc.state.userContent.length, 10);
    expect(userContentBloc.state.userContent.last.docID, '${length - 10}');
  });
  test('Test to paginate user content for artist page', () async {
    length = 50;
    final userContentBloc = await userContentBlocSetup();
    await userContentBloc.getUserContent(1);
    await userContentBloc.getUserContent(9);
    expect(userContentBloc.state.userContent.length, 20);
    expect(userContentBloc.state.userContent.last.docID, '30');
    await userContentBloc.getUserContent(2);
    await userContentBloc.getUserContent(3);
    expect(userContentBloc.state.userContent.length, 40);
    expect(userContentBloc.state.userContent.last.docID, '10');
  });
}

Future<KalaUserContentCubit> userContentBlocSetup() async {
  await populateFakeUserContentInFirestore(
    FirebaseMocks.mockFirestore,
    length,
  );
  log(FirebaseMocks.mockFirestore.dump());
  final userContentBloc = KalaUserContentCubit.mock();
  return userContentBloc;
}
