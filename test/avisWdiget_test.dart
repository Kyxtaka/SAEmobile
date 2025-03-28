


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saemobile/UI/avis.dart';

void main() {
  testWidgets('Vérifie si la page avis affiche le texte attendu', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Avis(),
    ));

    expect(find.text("Pas d'avis"), findsOneWidget);
  });
}