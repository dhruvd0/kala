import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/main.dart' as app;

import '../config/widget_tester.dart';
import '../mocks/firebase_mocks.dart';

void loginTestFlow() {
  testWidgets("Test to authenticate user and store user data in Firestore",
      (tester) async {
    WidgetTesterHandler widgetTesterHandler = WidgetTesterHandler(tester);
    await widgetTesterHandler.startAppWithMockFirebase(signedIn: false);

    await widgetTesterHandler.tester.pumpAndSettle();
    await widgetTesterHandler.waitFor(5);
    await widgetTesterHandler.tester.pumpAndSettle();
    await widgetTesterHandler.tapByKey("GoogleAuthBtn");
  });

  testWidgets("Test to auto-login user on startup", (tester) async {
    WidgetTesterHandler widgetTesterHandler = WidgetTesterHandler(tester);
    await widgetTesterHandler.startAppWithMockFirebase(signedIn: true);
    await widgetTesterHandler.waitFor(5);
    expect(widgetTesterHandler.findWidgetByKey("GoogleAuthBtn"), findsNothing);
  });
}
