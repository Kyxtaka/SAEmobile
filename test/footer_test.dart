import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';

class MockUserViewModel extends Mock implements UserViewModel {}

void main() {
  testWidgets('test affichage footer',
          (WidgetTester tester) async {
        late GoRouter router;

        final mockUserViewModel = MockUserViewModel();

        router = GoRouter(
          initialLocation: '/search',
          routes: [
            GoRoute(path: '/accueil', builder: (_, __) => const Text('Home')),
            GoRoute(path: '/search', builder: (_, __) => const Text('Search')),
            GoRoute(path: '/favoris', builder: (_, __) => const Text('Favoris')),
            GoRoute(path: '/avis', builder: (_, __) => const Text('Avis')),
            GoRoute(path: '/settings', builder: (_, __) => const Text('Settings')),
            GoRoute(path: '/profile/:id', builder: (_, state) => Text('Profile: ${state.pathParameters['id']}')),
            GoRoute(path: '/login', builder: (_, __) => const Text('Login')),
          ],
        );

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<UserViewModel>.value(value: mockUserViewModel),
            ],
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );


        await tester.pumpAndSettle();


        final footer = Footer();

        final navBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));

        await tester.tap(find.byIcon(Icons.restaurant_menu));
        await tester.pumpAndSettle();


      });
}
