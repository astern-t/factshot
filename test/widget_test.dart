import 'package:flutter_test/flutter_test.dart';
import 'package:factshot/app/app.dart';

void main() {
  testWidgets('FactShot onboarding screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FactShotApp());

    // Verify that the onboarding screen is rendered.
    expect(find.text('Skip'), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
