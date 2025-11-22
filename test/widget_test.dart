// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:gitbit_tracker/main.dart';
import 'package:gitbit_tracker/services/habit_service.dart';

void main() {
  testWidgets('App starts with no habits', (WidgetTester tester) async {
    // Initialize habit service
    final habitService = HabitService();
    await habitService.init();
    await habitService.clearAllHabits();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(habitService: habitService));

    // Verify that we see the empty state
    expect(find.text('No habits yet'), findsOneWidget);
    expect(
      find.text('Tap the + button to add your first habit'),
      findsOneWidget,
    );
  });
}
