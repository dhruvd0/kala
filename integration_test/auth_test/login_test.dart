import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kala/config/firebase/firebase.dart';
import 'package:kala/config/firebase/firestore_paths.dart';
import 'package:kala/main.dart' as app;

import '../config/widget_tester.dart';
import '../mocks/firebase_mocks.dart';

void loginTestFlow() {
  testWidgets("Test to authenticate user and store user data in Firestore",
      (tester) async {
    await FirebaseMocks.mockFirestore
        .collection(FirestorePaths.userCollection)
       .add({"test": "test"});
  
    FirebaseConfig mockFirebaseConfig = FirebaseConfig(
      firestoreInstance: FirebaseMocks.mockFirestore,
      firebaseAuthInstance: await FirebaseMocks.getMockAuthFromGoogleAuthMock(),
    );
    app.main(mockFirebase: mockFirebaseConfig);
    WidgetTesterHandler widgetTesterHandler = WidgetTesterHandler(tester);
    await widgetTesterHandler.tester.pumpAndSettle();
    await widgetTesterHandler.tapByKey("googleAuthBtn");
  
  });
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  loginTestFlow();
}
