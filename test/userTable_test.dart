import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:saemobile/models/user.dart';
import 'package:saemobile/services/local/tables/userTable.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  test('Insertion d\'un user dans la base de données', () async {
    final mockDb = MockDatabase();
    final dbService = UserTable(db:mockDb);
    final user = new User("mail@mail", "motdepasse", "Dupont", "Jean", "Visiteur", [], false, "");

    when(mockDb.insert('User',any??{})).thenAnswer((_) async => 1);

    final result = await dbService.insertUser(user);
    expect(result, 1);
  });
}
