import 'package:sqflite/sqflite.dart';
import 'package:saemobile/models/user.dart' as app_models;
import '../sqlfliteDatabase.dart';

class UserTable {

  Future<void> insertUser(app_models.User user) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.insert(
      'User',
      user.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUser(app_models.User user) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.update(
      'User',
      user.toMapLocal(),
      where: 'email = ?',
      whereArgs: [user.mail],
    );
  }

  Future<void> deleteUser(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.delete(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<app_models.User?> getUserByEmail(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, Object?>> result = await db.query(
      'User',
      where: 'mail = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return app_models.User.fromMap(result.first);
    }
    return null;
  }

  Future<List<app_models.User>> getAllUsers() async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, Object?>> usersMaps = await db.query('User');

    return usersMaps.map((map) {
      return app_models.User(
        mail: map['mail'] as String,
        password: map['password'] as String? ?? '',
        nom: map['nom'] as String? ?? '',
        prenom: map['prenom'] as String? ?? '',
        role: map['role'] as String? ?? '',
        tester: (map['tester'] as List<String>?) ?? [],
        connected: (map['connected'] as int) == 1,
        localisation: map['localisation'] as String? ?? '',
      );
    }).toList();
  }
}
