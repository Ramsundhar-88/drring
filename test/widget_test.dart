// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:drring/main.dart';

void main() {
  testWidgets('DrRing splash screen loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DrRingApp());

    // Verify that the splash screen is rendered with correct text.
    expect(find.text('DrRing'), findsOneWidget);
    expect(find.text('for Family'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);
  });
}
