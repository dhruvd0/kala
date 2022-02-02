// ignore_for_file: unawaited_futures

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/main.dart';

import 'artist_page_test/artist_page_test.dart';
import 'auth_test/login_flow_test.dart';
import 'dashboard_test/dashboard_test.dart';
import 'gallery_test/gallery_test.dart';
import 'startup_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() {
    firebaseConfig = null;
  });
  startupTest();
  group(
    'Authentication Tests',
    loginTestFlow,
  );

  group('Gallery Tests', galleryTestFlow);

  group('Dashboard Navigation Tests', dashboardIntegrationTests);

  group('Artist Page Tests', artistPageTests);
}
