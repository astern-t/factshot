import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:factshot/app/app.dart';

void main() {
  testWidgets('FactShot onboarding screen smoke test', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const FactShotApp());

    // Wait for the asynchronous initialization of AppState (SharedPreferences)
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify that the onboarding screen is rendered.
    expect(find.text('Skip'), findsOneWidget);
  });
}
