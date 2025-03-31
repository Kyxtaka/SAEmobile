import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:saemobile/UI/settings.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';

class MockUserViewModel extends Mock implements UserViewModel {}

void main() {
  late MockUserViewModel mockUserViewModel;

  setUp(() {
    mockUserViewModel = MockUserViewModel();
  });

  testWidgets('Affiche le type favori après chargement', (WidgetTester tester) async {

    when(mockUserViewModel.getType()).thenAnswer((_) async => "Italien");

    // Render le widget
    await tester.pumpWidget(MaterialApp(
      home: MyWidget(userViewModel: mockUserViewModel),
    ));

    // Vérifie que le texte "Chargement..." s'affiche d'abord
    expect(find.text("Votre type favori est : Chargement..."), findsOneWidget);

    // Attend que le Future se termine
    await tester.pumpAndSettle();

    // Vérifie que le texte "Votre type favori est : Italien" apparaît après chargement
    expect(find.text("Votre type favori est : Italien"), findsOneWidget);
  });

  testWidgets('Affiche "non renseigné" si aucun type n\'est trouvé', (WidgetTester tester) async {
    // Simule une valeur null pour getTypePreferee()
    when(mockUserViewModel.getTypePreferee()).thenAnswer((_) async => null);

    // Render le widget
    await tester.pumpWidget(MaterialApp(
      home: SettingsScreen(userViewModel: mockUserViewModel),
    ));
    await tester.pumpAndSettle();
    expect(find.text("Votre type favori est : non renseigné"), findsOneWidget);
  });
}
