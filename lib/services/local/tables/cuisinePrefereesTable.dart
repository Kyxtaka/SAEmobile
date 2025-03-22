import 'package:sqflite/sqflite.dart';

import '../sqlfliteDatabase.dart';

class CuisinesPrefereesTable {

  Future<void> insertCuisinePrefere(String email, int cuisineId) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.insert(
      'cuisines_preferees',
      {
        'email': email,
        'cuisine_id': cuisineId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteCuisinePrefere(String email, int cuisineId) async {
    final db = await SqlfliteDatabase.instance.database;
    return await db.delete(
      'cuisines_preferees',
      where: 'email = ? AND cuisine_id = ?',
      whereArgs: [email, cuisineId],
    );
  }

  Future<List<Map<String, Object?>>> getCuisinesPreferees(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    return await db.query(
      'cuisines_preferees',
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
