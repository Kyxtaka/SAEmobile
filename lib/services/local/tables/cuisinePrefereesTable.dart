import 'package:sqflite/sqflite.dart';
import '../../../models/typeCuisine.dart';
import '../sqlfliteDatabase.dart';

class CuisinesPreferees {

  final Database db;
  CuisinesPreferees({required this.db});

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

  Future<List<TypeCuisine>> getCuisinesPreferees(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    final cuisineMaps = await db.rawQuery('''
    SELECT c.*
    FROM cuisines_preferees cp
    INNER JOIN TypeCuisine c ON cp.cuisine_id = c.idCuisine
    WHERE cp.email = ?
  ''', [email]);
    return cuisineMaps.map((map) {
      return TypeCuisine(
          map['idCuisine'] as int,
          map['nomCuisine'] as String,
          map['imgCuisine'] as String
      );
    }).toList();
  }

  Future<List<TypeCuisine>> getAllTypeCuisines() async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, Object?>> typeCuisineMaps = await db.query('cuisines_preferees');
    return typeCuisineMaps.map((map) {
      return TypeCuisine(
          map['idCuisine'] as int,
          map['nomCuisine'] as String,
          map['imgCuisine'] as String
      );
    }).toList();
  }
}
