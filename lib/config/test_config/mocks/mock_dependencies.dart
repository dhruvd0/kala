import 'package:kala/config/register_singletons.dart';
import 'package:kala/config/test_config/mocks/firebase_mocks.dart';

Future<void> mockDependencies() async {
  getIt.registerSingleton(
    await FirebaseMocks().getMockFirebaseConfig(signedIn: true),
  );
}
