import 'package:sqflite/sqflite.dart';
import '../../../models/typeCuisine.dart';

class TypeCuisineTable {
  final db;
  TypeCuisineTable({required this.db});

  Future<int> insertTypeCuisine(TypeCuisine typeCuisine) async {
    return await db.insert(
      'TypeCuisine',
      typeCuisine.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTypeCuisine(TypeCuisine typeCuisine) async {
    return await db.update(
      'TypeCuisine',
      typeCuisine.toMapLocal(),
      where: 'id = ?',
      whereArgs: [typeCuisine.id],
    );
  }

  Future<int> deleteTypeCuisine(int id) async {
    return await db.delete(
      'TypeCuisine',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TypeCuisine>> getAllTypeCuisines() async {
    final List<Map<String, Object?>> typeCuisineMaps = await db.query('TypeCuisine');
    return typeCuisineMaps.map((map) {
      return TypeCuisine(
        map['idTypeCuisine'] as int,
        map['cuisine'] as String
      );
    }).toList();
  }
}

