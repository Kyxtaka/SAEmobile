

import 'package:sqflite/sqflite.dart';

import '../sqlfliteDatabase.dart';

class RestaurantsPrefereesDAO {

  Future<void> insertRestaurantPrefere(String email, int restaurantId) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.insert(
      'restaurants_preferees',
      {
        'email': email,
        'restaurant_id': restaurantId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteRestaurantPrefere(String email, int restaurantId) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.delete(
      'restaurants_preferees',
      where: 'email = ? AND restaurant_id = ?',
      whereArgs: [email, restaurantId],
    );
  }

  Future<List<Map<String, Object?>>> getRestaurantsPreferees(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    return await db.query(
      'restaurants_preferees',
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
