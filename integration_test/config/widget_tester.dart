// ignore_for_file: avoid_catching_errors


import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/main.dart' as app;

typedef WT = WidgetTester;

class WidgetTesterHandler {
  WidgetTesterHandler(this.tester) {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  }

  WT tester;

  Future<void> tapByKey(String key) async {
    await tester.ensureVisible(findWidgetByKey(key));
    await tester.tap(findWidgetByKey(key),warnIfMissed: false);

    await waitForFramesToSettle();
  }

  Finder findWidgetByText(String text) {
    return find.text(text);
  }

  Finder findWidgetByKey(String key) {
    return find.byKey(ValueKey(key),skipOffstage: false);
  }

  Future<void> waitForSeconds(int seconds) async {
    await Future<void>.delayed(Duration(seconds: seconds));
  }

  Future<void> waitForMilliSeconds(int mills) async {
    await Future<void>.delayed(Duration(milliseconds: mills));
  }

  Future<void> startAppWithMockFirebase({bool? signedIn}) async {
    final firebaseMocks = FirebaseMocks();
    final mockFirebaseConfig = app.firebaseConfig ??
        await firebaseMocks.getMockFirebaseConfig(signedIn: signedIn);
    // ignore: unawaited_futures
    app.main(mockFirebase: mockFirebaseConfig);

    await waitForFramesToSettle();
  }

  bool isWidgetInTree(String key) {
    try {
      expect(findWidgetByKey(key), findsWidgets);
      return true;
    } on TestFailure {
      return false;
    }
  }

  Future<void> enterTextInWidget(String key, String text) async {
    await tester.enterText(findWidgetByKey(key), text);
  }

  Future<void> pumTenFrames() async {
    for (var i = 0; i < 10; i++) {
      await tester.pump();
    }
  }

  Future<void> waitForFramesToSettle() async {
    try {
      await tester.pumpAndSettle(
        const Duration(milliseconds: 500),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 20),
      );
    } on FlutterError {
      //
    }
  }
}
