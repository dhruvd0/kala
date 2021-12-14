import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

typedef WT = WidgetTester;

class WidgetTesterHandler {
  WT tester;
  WidgetTesterHandler(this.tester);

  Future<void> tapByKey(String key) async {
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }
}
