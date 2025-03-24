import 'package:saemobile/models/restaurant.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/critique.dart';
import '../../../models/user.dart';
import '../sqlfliteDatabase.dart';

class CritiqueTable {

  Future<void> insertCritique(Critique critique) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.insert(
      'Critique',
      critique.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCritique(Critique critique) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.update(
      'Critique',
      critique.toMapLocal(),
      where: 'id = ?',
      whereArgs: [critique.id],
    );
  }

  Future<void> deleteCritique(int id) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.delete(
      'Critique',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Critique>> getAllCritiques() async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, Object?>> critiquesMaps = await db.query('Critique');
    return critiquesMaps.map((map) {
      return Critique(
        map['id'] as int,
        map['message'] as String,
        map['restaurant'] = null,
        map['user'] = null,
        map['date_test'] = '',
        map['note'] as int,
      );
    }).toList();
  }

  Future<List<Critique>> getCritiquesByUser(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, Object?>> critiquesMaps = await db.query(
      'Critique',
      where: 'email = ?',
      whereArgs: [email],
    );
    return critiquesMaps.map((map) {
      return Critique(
        map['id'] as int,
        map['message'] as String,
        map['restaurant'] = null,
        map['user'] = null,
        map['date_test'] = '',
        map['note'] as int,
      );
    }).toList();
  }
}
