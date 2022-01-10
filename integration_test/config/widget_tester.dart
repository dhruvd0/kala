import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';
import 'package:kala/main.dart' as app;


typedef WT = WidgetTester;

class WidgetTesterHandler {
  WT tester;
  WidgetTesterHandler(this.tester){
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  }

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
