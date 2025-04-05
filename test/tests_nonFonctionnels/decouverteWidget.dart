import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:saemobile/UI/research/decouverte.dart';
import 'package:saemobile/api/restaurantAPI.dart';
import 'package:saemobile/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../classes_test/TestDecouverte.dart';


class MockRestaurantAPI extends Mock implements RestaurantAPI {}
class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late MockRestaurantAPI mockRestaurantAPI;
  late MockSupabaseClient mockSupabaseClient;
  late MockSharedPreferences mockSharedPreferences;
  SharedPreferences.setMockInitialValues({});
  TestWidgetsFlutterBinding.ensureInitialized();
  final mockRestaurants = [
    Restaurant(
        1, 'Restaurant 1', '123 Rue Test', 50, '123456789', 'SIRET123456',
        'http://example.com', 'http://example.com/photo1.jpg',
        1, 1, 3, '08:00 - 22:00', 48.8566, 2.3522),
  ];

  setUp(() async {
    await Supabase.initialize(
      url: 'https://your.supabase.url',
      anonKey: 'your-anon-key',
    );
    SharedPreferences.setMockInitialValues({});
    mockSupabaseClient = MockSupabaseClient();
    mockRestaurantAPI = MockRestaurantAPI();
    mockSharedPreferences = MockSharedPreferences();

    when(mockRestaurantAPI.getAllRestaurants()).thenAnswer((_) async => mockRestaurants);
  });
  testWidgets('Test de la page Decouverte', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/decouverte',
          routes: [
            GoRoute(
              path: '/decouverte',
              builder: (context, state) => TestableDecouverte(testApi: mockRestaurantAPI)),]
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Restaurant 1'), findsOneWidget);
    expect(find.text('123 Rue Test'), findsOneWidget);
    expect(find.text('Restaurant 2'), findsOneWidget);
    expect(find.text('456 Rue Test'), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsNothing);

    expect(find.byType(ListView), findsOneWidget);

    expect(find.byType(Card), findsNWidgets(mockRestaurants.length));

    expect(find.text('Les détails'), findsWidgets);
  });
}
