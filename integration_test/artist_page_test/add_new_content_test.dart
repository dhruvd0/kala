import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/artist_page/add_new_content/widgets/keys/add_new_content_widget_keys.dart';
import 'package:kala/artist_page/widgets/keys/artist_page/artist_page_keys.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/config/widget_keys/nav_keys.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/gallery/content/widgets/keys.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

import '../config/widget_tester.dart';

void testToAddNewContent() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'Test to create and add new content and show it in Gallery, Artist Content Grid',
    (tester) async {
      final widgetTesterHandler = WidgetTesterHandler(tester);
      await widgetTesterHandler.startAppWithMockFirebase(signedIn: true);
      await widgetTesterHandler.pumTenFrames();
      await widgetTesterHandler.tapByKey(
        NavWidgetKeys.pageNavArrowKey(
          ScaffoldKeys.galleryPageKey,
          NavArrowType.right,
        ),
      );
      await widgetTesterHandler.tester.dragUntilVisible(
        widgetTesterHandler.findWidgetByKey(ArtistPageKeys.toggleEditModeBtn),
        widgetTesterHandler.findWidgetByKey(ScaffoldKeys.dashboard),
        const Offset(200, 0),
      );
      await widgetTesterHandler.tapByKey(ArtistPageKeys.toggleEditModeBtn);

      await widgetTesterHandler.tapByKey(AddNewContentWidgetKeys.emptyContent);
      final content = ContentMock.fakeContent(100);
      await widgetTesterHandler.enterTextInWidget(
        describeEnum(ContentProps.title),
        content.title,
      );
      await widgetTesterHandler.enterTextInWidget(
        describeEnum(ContentProps.price),
        content.description,
      );
      await widgetTesterHandler
          .tapByKey(AddNewContentWidgetKeys.submitContentButton);
      await widgetTesterHandler.tapByKey(
        NavWidgetKeys.pageNavArrowKey(
          ScaffoldKeys.artistPageKey,
          NavArrowType.left,
        ),
      );
      await widgetTesterHandler.waitForSeconds(2);
      expect(
        widgetTesterHandler.findWidgetByKey(
          ContentCardKey.key(ContentViewMode.grid, content.docID),
        ),
        findsWidgets,
      );
    },
  );
}

void main() {
  testToAddNewContent();
}
