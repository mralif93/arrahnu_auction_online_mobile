// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:arrahnu_auction_online_mobile/main.dart';

void main() {
  testWidgets('GetX Material Design app with Account tab loads correctly', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for GetX to initialize
    await tester.pumpAndSettle();

    // Verify that the app loads with Material bottom navigation
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);

    // Verify home page content loads
    expect(find.text('Ar-Rahnu Auction'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);

    // Test navigation to account tab (tap on the tab bar item)
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();

    // Verify login page loads by default in account tab
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(
      find.text(
        'Sign in to your Ar-Rahnu account and continue your auction journey',
      ),
      findsOneWidget,
    );
  });
}
