import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/main.dart' as app;

import 'auth_test/login_test_flow.dart';
import 'config/widget_tester.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("App Start", (tester) async {
    app.main();
    WidgetTesterHandler widgetTesterHandler = WidgetTesterHandler(tester);
    await widgetTesterHandler.tester.pumpAndSettle();
  });
  group("Authentication Tests", () {
    loginTestFlow();
  });
}
