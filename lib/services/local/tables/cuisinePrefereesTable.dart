import 'package:flutter/material.dart';
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


  /// get les cuisines favorites pour un utilisateur
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
    var favoris = "";
    for (var i = 0;i<result.length;i++){
      favoris += result[i]['cuisine'].toString() + ", ";
    }
    return favoris;
  }

  /// suppression cuisine favorite
  static Future<void> deleteCuisinePrefere(String email, String cuisine) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.delete(
      'cuisines_preferees',
      where: 'email = ? AND cuisine = ?',
      whereArgs: [email, cuisine],
    );
  }

}
