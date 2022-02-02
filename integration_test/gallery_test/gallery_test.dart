import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/gallery/content/widgets/content_card.dart';

import '../config/widget_tester.dart';

void galleryTestFlow() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test to load gallery content on login', (tester) async {
    final widgetTester = WidgetTesterHandler(tester);
    await ContentMock().populateFakeContentInFirestore(20);
    await widgetTester.startAppWithMockFirebase(signedIn: true);

    await widgetTester.pumTenFrames();
    expect(find.byType(ContentCard), findsWidgets);
  });
}

void main() {
  galleryTestFlow();
}
