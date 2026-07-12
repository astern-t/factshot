import 'package:flutter_test/flutter_test.dart';
import 'package:factshot/main.dart';

void main() {
  testWidgets('FactShot splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FactShotApp());

    // Verify that the splash screen title is rendered.
    expect(find.text('FACTSHOT'), findsOneWidget);

    // Pump the timer so the splash screen transitions and settles
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
