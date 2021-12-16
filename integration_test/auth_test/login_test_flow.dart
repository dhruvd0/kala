import 'package:flutter_test/flutter_test.dart';

import '../config/widget_tester.dart';

void loginTestFlow() {
  testWidgets("Test to authenticate user and store user data in Firestore",
      (tester) async {
    WidgetTesterHandler widgetTesterHandler = WidgetTesterHandler(tester);
    await widgetTesterHandler.startAppWithMockFirebase(signedIn: false);

    await widgetTesterHandler.tester.pumpAndSettle();
    await widgetTesterHandler.waitFor(5);
    await widgetTesterHandler.tester.pumpAndSettle();
    await widgetTesterHandler.tapByKey("GoogleAuthBtn");
  },skip: true);

  testWidgets("Test to auto-login user on startup", (tester) async {
    WidgetTesterHandler widgetTesterHandler = WidgetTesterHandler(tester);
    await widgetTesterHandler.startAppWithMockFirebase(signedIn: true);
    await widgetTesterHandler.waitFor(5);
    expect(widgetTesterHandler.findWidgetByKey("GoogleAuthBtn"), findsNothing);
  });
}
