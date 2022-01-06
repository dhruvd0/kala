import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kala/main.dart' as app;
import '../mocks/firebase_mocks.dart';

typedef WT = WidgetTester;

class WidgetTesterHandler {
  WT tester;
  WidgetTesterHandler(this.tester);

  Future<void> tapByKey(String key) async {
    await tester.tap(findWidgetByKey(key));
    await tester.pumpAndSettle();
  }

  Finder findWidgetByKey(String key) {
    return find.byKey(Key(key));
  }

  Future<void> waitFor(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
  }

  Future<void> startAppWithMockFirebase({bool? signedIn}) async {
    var mockFirebaseConfig =
        await FirebaseMocks.getMockFirebaseConfig(signedIn: signedIn);
    app.main(mockFirebase: mockFirebaseConfig);
    await tester.pumpAndSettle();
    await waitFor(2);
  }
}
