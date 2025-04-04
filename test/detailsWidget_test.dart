import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:saemobile/UI/details.dart';
import 'package:saemobile/api/restaurantAPI.dart';
import 'package:go_router/go_router.dart';
import 'package:saemobile/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockRestaurantAPI extends Mock implements RestaurantAPI {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late MockRestaurantAPI mockRestaurantAPI;
  late MockSharedPreferences mockSharedPreferences;
  late MockSupabaseClient mockSupabaseClient;

  setUp(() async {
    await Supabase.initialize(
      url: 'https://your.supabase.url',
      anonKey: 'your-anon-key',
    );

    mockRestaurantAPI = MockRestaurantAPI();
    mockSupabaseClient = MockSupabaseClient();
    mockSharedPreferences = MockSharedPreferences();

    testWidgets('Test widget DetailsPage', (WidgetTester tester) async {

      await when(() => mockSharedPreferences.getString('identifier'));
      await when(() => mockSharedPreferences.getString('hashPassword'));

      await tester.pumpWidget(
        MaterialApp(
          home: DetailsPage(restaurantId: '1'),
        ),
      );

    when(() => Supabase.instance.client).thenReturn(mockSupabaseClient);

    when(() => RestaurantAPI.getRestaurantById(any())).thenAnswer(
          (_) async => Restaurant(
        1,
        'Restaurant Test',
        '123 Rue Test',
        50,
        '123456789',
        'SIRET123',
        'www.restauranttest.com',
        'https://via.placeholder.com/150',
        1,
        1,
        5,
        '9h-22h',
        48.8566,
        2.3522,
      ),
    );
  });


  testWidgets('Test DetailsPage s\'affiche correctement', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/details/1',
          routes: [
            GoRoute(
              path: '/details/:id',
              builder: (BuildContext context, GoRouterState state) {
                final id = state.pathParameters['id']!;
                return DetailsPage(restaurantId: id);
              },
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

      expect(find.text('Adresse'), findsOneWidget);
    expect(find.text('123 Rue Test'), findsOneWidget);
    expect(find.text('Type : Non renseigné'), findsOneWidget);
    expect(find.text('50 personnes'), findsOneWidget);
    expect(find.text('123456789'), findsOneWidget);
    expect(find.text('Les Avis'), findsOneWidget);
    expect(find.text('Donner un avis'), findsOneWidget);

    await tester.tap(find.text('Les Avis'));
    await tester.pumpAndSettle();
    expect(find.byType(DetailsPage), findsOneWidget);

  });});}

