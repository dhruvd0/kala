import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/gallery/content/models/content.dart';

import '../config/widget_tester.dart';
import '../mocks/content_mocks.dart';
import '../mocks/firebase_mocks.dart';

void galleryTestFlow() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Test to load gallery content on login", (tester) async {
    WidgetTesterHandler widgetTester = WidgetTesterHandler(tester);
    await populateFakeContent();
    await widgetTester.startAppWithMockFirebase(signedIn: true);
    expect(widgetTester.findWidgetByKey("Content0"), findsOneWidget);
    expect(widgetTester.findWidgetByKey("Content1"), findsOneWidget);
  });
}

Future<void> populateFakeContent() async {
  for (int i = 0; i < 10; i++) {
    await FirebaseMocks.mockFirestore.collection("content").add(
          ContentMock.fakeContent(i).toMap(),
        );
  }
}
