import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';

import 'package:kala/main.dart' as app;

typedef WT = WidgetTester;

class WidgetTesterHandler {
  WT tester;
  WidgetTesterHandler(this.tester) {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  }

  Future<void> tapByKey(String key) async {
    await tester.tap(findWidgetByKey(key));

    await pumTenFrames();
  }

  Finder findWidgetByText(String text) {
    return find.text(text);
  }

  Finder findWidgetByKey(String key) {
    return find.byKey(ValueKey(key));
  }

  Future<void> waitForSeconds(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
  }

  Future<void> waitForMilliSeconds(int mills) async {
    await Future.delayed(Duration(milliseconds: mills));
  }

  Future<void> startAppWithMockFirebase({bool? signedIn, W}) async {
    var mockFirebaseConfig =
        await FirebaseMocks.getMockFirebaseConfig(signedIn: signedIn);
    app.main(mockFirebase: mockFirebaseConfig);

    await pumTenFrames();
    print("App Started");
  }

  Future<void> pumTenFrames() async {
    for (int i = 0; i < 10; i++) {
      await tester.pump();
    }
  }
}
