
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:saemobile/UI/login.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:saemobile/utils/UserTools.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  testWidgets('Test Login avec succès', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Login(userViewModel: mockUserViewModel, database: mockDatabase),
    ));

    await tester.enterText(find.byType(FormBuilderTextField).first, "test@example.com");
    await tester.enterText(find.byType(FormBuilderTextField).last, "password123");

    await tester.tap(find.text("Se connecter"));
    await tester.pumpAndSettle();

  });


}
