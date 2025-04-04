import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:saemobile/UI/login.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:saemobile/utils/UserTools.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Mock classes
class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockUserViewModel extends Mock implements UserViewModel {}
class MockUserTools extends Mock implements UserTools {}

void main() {
  late MockSupabaseClient mockDatabase;
  late MockUserViewModel mockUserViewModel;
  late MockUserTools mockUserTools;

  setUp(() {
    mockDatabase = MockSupabaseClient();
    mockUserViewModel = MockUserViewModel();
    mockUserTools = MockUserTools();
  });

  testWidgets('Test sur les boutons/fields de la page Test, s\'affiche correctement', (WidgetTester tester) async {
    final GoRouter router = GoRouter(
      routes: [GoRoute(path: '/', builder: (context, state) => Login(userViewModel: UserViewModel(database: mockDatabase, context: context), database: mockDatabase,))],
    );

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
      builder: (context, child) => Login(userViewModel: mockUserViewModel, database: mockDatabase),
    ));

    expect(find.text("Connexion"), findsOneWidget);
    expect(find.byType(FormBuilderTextField), findsNWidgets(2)); // Email & Password
    expect(find.text("Se connecter"), findsOneWidget);

    await tester.tap(find.text("Se connecter"));
    await tester.pump();
    expect(find.text("Veuillez entrer un email"), findsOneWidget);
    expect(find.text("Le mot de passe doit contenir au moins 8 caractères"), findsOneWidget);

    await tester.enterText(find.byType(FormBuilderTextField).first, "test@example.com");
    await tester.enterText(find.byType(FormBuilderTextField).last, "password123");
    await tester.tap(find.text("Se connecter"));
    await tester.pump();

    verify(mockUserViewModel.setConnection(any??"", any??"")).called(1);
  });
}
