import 'package:flutter_test/flutter_test.dart';
import 'package:kala/auth/social_integration/auth_types.dart';

import '../config/widget_tester.dart';

void loginTestFlow() {
  testWidgets(
    "Test to find auth buttons if not logged in",
    (tester) async {
      WidgetTesterHandler widgetTesterHandler = WidgetTesterHandler(tester);
      await widgetTesterHandler.startAppWithMockFirebase(signedIn: false);

      await widgetTesterHandler.tester.pumpAndSettle();
      await widgetTesterHandler.waitFor(5);

      await widgetTesterHandler.tester.pumpAndSettle();
      AuthTypes.allAuthTypes().forEach((type) {
        expect(
          widgetTesterHandler.findWidgetByKey("${type}AuthBtn"),
          findsOneWidget,
        );
      });
    },
  );

  testWidgets(
    "Test to auto-login user on startup",
    (tester) async {
      WidgetTesterHandler widgetTesterHandler = WidgetTesterHandler(tester);
      await widgetTesterHandler.startAppWithMockFirebase(signedIn: true);
      await widgetTesterHandler.waitFor(5);
      expect(
        widgetTesterHandler.findWidgetByKey("GoogleAuthBtn"),
        findsNothing,
      );
    },
  );
}
