import 'package:sqflite/sqflite.dart';
import '../sqlfliteDatabase.dart';

class CuisinesPrefereesTable {

  static Future<void> insertCuisinePrefere(String email, int cuisineId, cuisine) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.insert(
      'cuisines_preferees',
      {
        'email': email,
        'cuisine_id': cuisineId,
        'cuisine': cuisine
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

  static Future<String> getCuisinesPreferees(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    var result = await db.query(
      'cuisines_preferees',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isEmpty){
      return "non renseigné";
    }
    return result[2].toString();
  }
}
