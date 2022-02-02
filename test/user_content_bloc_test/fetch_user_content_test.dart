
import 'package:flutter_test/flutter_test.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/utils/helper_bloc/content_pagination/pagination_state.dart';

int length = 10;
void main() {
  test('Test to get initial user content for artist page', () async {
    final userContentBloc = await userContentBlocSetup();
    await userContentBloc.getUserContent(
      1,
      collectionSegment: CollectionSegment.initial,
    );
    expect(userContentBloc.state.userContent?.isNotEmpty, true);
    expect(userContentBloc.state.userContent?.first.title, '${length - 1}');
    expect(userContentBloc.state.userContent?.length, 10);
    expect(userContentBloc.state.userContent?.last.title, '${length - 10}');
  });
  test('Test to paginate user content for artist page', () async {
    length = 50;
    final userContentBloc = await userContentBlocSetup();
    await userContentBloc.getUserContent(
      1,
      collectionSegment: CollectionSegment.initial,
    );
    await userContentBloc.getUserContent(
      9,
      collectionSegment: CollectionSegment.next,
    );
    expect(userContentBloc.state.userContent?.length, 20);
    expect(userContentBloc.state.userContent?.last.title, '30');
    await userContentBloc.getUserContent(
      2,
      collectionSegment: CollectionSegment.next,
    );
    await userContentBloc.getUserContent(
      3,
      collectionSegment: CollectionSegment.next,
    );
    expect(userContentBloc.state.userContent?.length, 40);
    expect(userContentBloc.state.userContent?.last.title, '10');
  });
}

Future<KalaUserContentBloc> userContentBlocSetup() async {
  await ContentMock().populateFakeContentInFirestore(
    length,
  );

  final userContentBloc = KalaUserContentBloc.mock();
  return userContentBloc;
}
