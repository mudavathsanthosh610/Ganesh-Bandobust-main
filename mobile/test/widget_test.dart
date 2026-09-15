import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ganesh_bandobust_mobile/main.dart';

void main() {
  testWidgets('Ganesh Bandobust app starts successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GaneshBandobustApp());

    expect(find.text('GANESH FESTIVAL'), findsOneWidget);
    expect(find.text('Official Login'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);

    final loginButton = find.byType(FilledButton);
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Ganesh Bandobust 2026'), findsOneWidget);
    expect(find.text('Field Officer Demo'), findsOneWidget);
    expect(find.text('3 assigned applications'), findsOneWidget);
  });
}