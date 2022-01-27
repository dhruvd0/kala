import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'config/widget_tester.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  startupTest();
}

void startupTest() {
  testWidgets(
    'App Start',
    (tester) async {
      final widgetTesterHandler = WidgetTesterHandler(tester);
      await widgetTesterHandler.startAppWithMockFirebase();
    },
  );
}
