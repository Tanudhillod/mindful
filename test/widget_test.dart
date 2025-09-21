import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful_app/app.dart'; // Adjust import based on your project structure

void main() {
  // Test group for the main app widget
  group('Mindful App Widget Tests', () {
    // Test the initial rendering of the app
    testWidgets('App renders Home screen with navigation bar', (WidgetTester tester) async {
      // Build the app and trigger a frame
      await tester.pumpWidget(const MyApp());

      // Verify the app bar title is present
      expect(find.text('Mindful'), findsOneWidget);

      // Verify the navigation bar tabs are present
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Mood'), findsOneWidget);
      expect(find.text('Coping'), findsOneWidget);
      expect(find.text('Challenges'), findsOneWidget);

      // Verify the Home screen is initially displayed
      expect(find.text('Welcome to your wellness journey'), findsOneWidget);
      expect(find.text('Your Mental Wellness Companion'), findsOneWidget);
    });

    // Test navigation between tabs
    testWidgets('Tapping tabs navigates to respective screens', (WidgetTester tester) async {
      // Build the app and trigger a frame
      await tester.pumpWidget(const MyApp());

      // Initially, Home screen is active
      expect(find.text('Welcome to your wellness journey'), findsOneWidget);

      // Tap Chat tab
      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();

      // Verify Chat screen is displayed
      expect(find.text('Type your message here...'), findsOneWidget);

      // Tap Mood tab
      await tester.tap(find.text('Mood'));
      await tester.pumpAndSettle();

      // Verify Mood screen is displayed
      expect(find.text('Track your daily emotions and discover patterns in your mental wellness journey'), findsOneWidget);

      // Tap Coping tab
      await tester.tap(find.text('Coping'));
      await tester.pumpAndSettle();

      // Verify Coping screen is displayed
      expect(find.text('Instant Coping Tools'), findsOneWidget);

      // Tap Challenges tab
      await tester.tap(find.text('Challenges'));
      await tester.pumpAndSettle();

      // Verify Challenges screen is displayed
      expect(find.text('Wellness Challenges'), findsOneWidget);
    });
  });
}