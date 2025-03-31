import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:saemobile/UI/research/dropdownbutton.dart';
import 'package:saemobile/UI/settings.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:saemobile/models/typeCuisine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockUserViewModel extends Mock implements UserViewModel {}
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockUserViewModel mockUserViewModel;
  late MockHttpClient mockHttpClient;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
        url: dotenv.env['SUPABASE_DB_API_URL']??'',
        anonKey: dotenv.env['SUPABASE_ANON_KEY']??''
    );
  });
  setUp(() {
    mockUserViewModel = MockUserViewModel();
    mockHttpClient = MockHttpClient();
  });

  group('Tests page settings', ()
  {
    testWidgets(
        'Affiche le type favori après chargement', (WidgetTester tester) async {

      final GoRouter _router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return SettingsScreen(userViewModel: mockUserViewModel);
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerDelegate: _router.delegate(),
          routeInformationParser: _router.defaultRouteParser(),
        ),
      );
      when(() => mockUserViewModel.getTypePreferee()).thenAnswer((
          _) async => "Italien");

      await tester.pumpWidget(MaterialApp(
        home: SettingsScreen(userViewModel: mockUserViewModel),
      ));

      expect(
          find.text("Votre type favori est : non renseigné"), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Votre type favori est : Italien"), findsOneWidget);
    });

    testWidgets('Affiche un menu déroulant avec des types de cuisine', (
        WidgetTester tester) async {
      when(() => mockUserViewModel.getTypePreferee()).thenAnswer((
          _) async => "Italien");

      final List<TypeCuisine> cuisines = [
        TypeCuisine(1, "Française"),
        TypeCuisine(2, "Mexicaine"),
        TypeCuisine(3, "Chinoise"),
      ];

      await tester.pumpWidget(MaterialApp(
        home: SettingsScreen(userViewModel: mockUserViewModel),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(DropdownTypeCuisine), findsOneWidget);
    });

    testWidgets('Déconnexion fonctionne', (WidgetTester tester) async {
      when(() => mockUserViewModel.getTypePreferee()).thenAnswer((
          _) async => "Italien");
      when(() => mockUserViewModel.setDisconnection()).thenAnswer((_) async {});

      await tester.pumpWidget(MaterialApp(
        home: SettingsScreen(userViewModel: mockUserViewModel),
      ));

      await tester.pumpAndSettle();

      final Finder button = find.text('Déconnexion');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      verify(() => mockUserViewModel.setDisconnection()).called(1);
    });
  });
}
