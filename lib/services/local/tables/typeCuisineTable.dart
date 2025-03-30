import 'package:sqflite/sqflite.dart';
import '../../../models/typeCuisine.dart';
import '../sqlfliteDatabase.dart';

class TypeCuisineTable {
  Future<void> insertTypeCuisine(TypeCuisine typeCuisine) async {
    final db = await SqlfliteDatabase.instance.database;
     await db.insert(
      'TypeCuisine',
      typeCuisine.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTypeCuisine(TypeCuisine typeCuisine) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.update(
      'TypeCuisine',
      typeCuisine.toMapLocal(),
      where: 'id = ?',
      whereArgs: [typeCuisine.id],
    );
  }

  Future<void> deleteTypeCuisine(int id) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.delete(
      'TypeCuisine',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TypeCuisine>> getAllTypeCuisines() async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, Object?>> typeCuisineMaps = await db.query('TypeCuisine');
    return typeCuisineMaps.map((map) {
      return TypeCuisine(
        map['idTypeCuisine'] as int,
        map['cuisine'] as String
      );
    }).toList();
  }
}

