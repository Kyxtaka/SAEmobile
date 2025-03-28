// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saemobile/UI/home.dart';

void main() {
  testWidgets('Vérifie si Login affiche le texte attendu', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Home(),
    ));

    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Inscrivez-vous !'), findsOneWidget);
    expect(find.text('Pas de compte ?'), findsOneWidget);

  });
}