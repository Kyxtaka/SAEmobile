import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saemobile/UI/home.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('Tests sur la page Home et elements UI', (WidgetTester tester) async {
    final GoRouter goRouter = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => Home()),
      GoRoute(path: '/login', builder: (context, state) => Container()),
      GoRoute(path: '/signIn', builder: (context, state) => Container()),
    ]);

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: goRouter,
    ));
    expect(find.text("Se connecter"), findsOneWidget);

    expect(find.text("Pas de compte ?"), findsOneWidget);

    expect(find.text("Inscrivez-vous !"), findsOneWidget);
    await tester.tap(find.text("Se connecter"));
    await tester.pump();
    await tester.tap(find.text("Inscrivez-vous !"));
    await tester.pump();
  });
}