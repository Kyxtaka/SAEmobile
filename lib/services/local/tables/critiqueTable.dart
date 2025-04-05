
import 'package:sqflite/sqflite.dart';

import '../../../models/critique.dart';

class CritiqueTable {
  final db;
  CritiqueTable({required this.db});

  Future<int> insertCritique(Critique critique) async {
    return await db.insert(
      'Critique',
      critique.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCritique(Critique critique) async {
    return await db.update(
      'Critique',
      critique.toMapLocal(),
      where: 'id = ?',
      whereArgs: [critique.id],
    );
  }

  Future<int> deleteCritique(int id) async {
    return await db.delete(
      'Critique',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Critique>> getAllCritiques() async {
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
