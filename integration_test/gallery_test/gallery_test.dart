import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/config/test_config/mocks/content_mocks.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';

import '../config/widget_tester.dart';


void galleryTestFlow() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Test to load gallery content on login", (tester) async {
    WidgetTesterHandler widgetTester = WidgetTesterHandler(tester);
    await populateFakeContentInFirestore(FirebaseMocks.mockFirestore,20);
    await widgetTester.startAppWithMockFirebase(signedIn: true);
    expect(widgetTester.findWidgetByKey("Content0"), findsOneWidget);
    expect(widgetTester.findWidgetByKey("Content1"), findsOneWidget);
  });
}

