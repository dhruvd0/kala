// ignore_for_file: unawaited_futures

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/main.dart' as app;

import 'auth_test/login_flow_test.dart';
import 'config/widget_tester.dart';
import 'dashboard_test/dashboard_test.dart';
import 'gallery_test/gallery_test.dart';

void main() {

  
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'App Start',
    (tester) async {
      app.main();
      final widgetTesterHandler = WidgetTesterHandler(tester);
      await widgetTesterHandler.startAppWithMockFirebase();
    },
  );
  group(
    'Authentication Tests',
    loginTestFlow,
  );

  group('Gallery Tests', galleryTestFlow);

  group('Dashboard Navigation Tests', dashboardIntegrationTests);
}
