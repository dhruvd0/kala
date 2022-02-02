import 'package:flutter_test/flutter_test.dart';
import 'package:kala/artist_page/widgets/keys/artist_page/artist_page_keys.dart';
import 'package:kala/config/widget_keys/nav_keys.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

import '../config/widget_tester.dart';
import 'add_new_content_test.dart';

void artistPageTests() {
  testToAddNewContent();

  group('Test to edit bio, name and cover content', () {
    testWidgets('Test to edit Bio', (tester) async {
      final widgetTester = WidgetTesterHandler(tester);
      await widgetTester.startAppWithMockFirebase(signedIn: true);

      await widgetTester.tapByKey(
        NavWidgetKeys.pageNavArrowKey(
          ScaffoldKeys.galleryPageKey,
          NavArrowType.right,
        ),
      );
      await widgetTester.tapByKey(ArtistPageKeys.toggleEditModeBtn);
      await widgetTester.tapByKey(ArtistPageKeys.editBioKey);
      await widgetTester.tester.enterText(
        widgetTester.findWidgetByKey(ArtistPageKeys.editBioKey),
        'test_bio',
      );
      await widgetTester.tapByKey(ArtistPageKeys.toggleEditModeBtn);
      expect(widgetTester.findWidgetByText('test_bio'), findsOneWidget);
    });
  });
}
