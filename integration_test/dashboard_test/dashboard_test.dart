import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/config/widget_keys/nav_keys.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

import '../config/widget_tester.dart';

void dashboardIntegrationTests() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test to navigate to next/prev pages on arrow button tap',
      (tester) async {
    final widgetTester = WidgetTesterHandler(tester);
    await widgetTester.startAppWithMockFirebase(signedIn: true);

    await widgetTester.tapByKey(
      NavWidgetKeys.pageNavArrowKey(
        ScaffoldKeys.galleryPageKey,
        NavArrowType.right,
      ),
    );

    expect(
      widgetTester.findWidgetByKey(ScaffoldKeys.artistPageKey),
      findsWidgets,
    );

    await widgetTester.tapByKey(
      NavWidgetKeys.pageNavArrowKey(
        ScaffoldKeys.artistPageKey,
        NavArrowType.right,
      ),
    );

    expect(
      widgetTester.findWidgetByKey(ScaffoldKeys.acquiresPageKey),
      findsWidgets,
    );
    await widgetTester.tapByKey(
      NavWidgetKeys.pageNavArrowKey(
        ScaffoldKeys.acquiresPageKey,
        NavArrowType.left,
      ),
    );
    await widgetTester.tapByKey(
      NavWidgetKeys.pageNavArrowKey(
        ScaffoldKeys.artistPageKey,
        NavArrowType.left,
      ),
    );
    expect(
      widgetTester.findWidgetByKey(ScaffoldKeys.galleryPageKey),
      findsWidgets,
    );
  });
}

void main() {
  dashboardIntegrationTests();
}
