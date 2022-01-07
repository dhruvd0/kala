import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/main.dart' as app;

import 'auth_test/login_flow_test.dart';
import 'config/widget_tester.dart';
import 'gallery_test/gallery_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("App Start", (tester) async {
    app.main();
    WidgetTesterHandler widgetTesterHandler = WidgetTesterHandler(tester);
    await widgetTesterHandler.tester.pumpAndSettle();
  }, skip: true);
  group("Authentication Tests", () {
    loginTestFlow();
  },skip: true);

  group("Gallery Tests", () {
    galleryTestFlow();
  });
}
