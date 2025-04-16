import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:name_app/main.dart'; // Adjust this to your actual import

void main() {
  testWidgets('UI elements are displayed', (WidgetTester tester) async {
    await tester.pumpWidget(NameApp());

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Enter name'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('Entering valid name shows success and greeting', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(NameApp());

    await tester.enterText(find.byType(TextField), 'Alice');
    await tester.tap(find.text('Save'));
    await tester.pump(); // Rebuild widget after tap

    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Hello, Alice'), findsOneWidget);
  });

  testWidgets('Entering invalid name (numbers) shows error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(NameApp());

    await tester.enterText(find.byType(TextField), 'Alice123');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Error: Use letters only'), findsOneWidget);
    expect(find.textContaining('Hello'), findsNothing);
  });

  testWidgets('Empty input shows error', (WidgetTester tester) async {
    await tester.pumpWidget(NameApp());

    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Error: Use letters only'), findsOneWidget);
    expect(find.textContaining('Hello'), findsNothing);
  });

  testWidgets('Symbols-only input shows error', (WidgetTester tester) async {
    await tester.pumpWidget(NameApp());

    await tester.enterText(find.byType(TextField), '@#\$%^');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Error: Use letters only'), findsOneWidget);
    expect(find.textContaining('Hello'), findsNothing);
  });
}
