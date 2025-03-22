

import 'package:sqflite/sqflite.dart';

import '../sqlfliteDatabase.dart';

class RestaurantsPrefereesDAO {
  final db;
  RestaurantsPrefereesDAO({required this.db});

  Future<int> insertRestaurantPrefere(String email, int restaurantId) async {
    return await db.insert(
      'restaurants_preferees',
      {
        'email': email,
        'restaurant_id': restaurantId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteRestaurantPrefere(String email, int restaurantId) async {
    return await db.delete(
      'restaurants_preferees',
      where: 'email = ? AND restaurant_id = ?',
      whereArgs: [email, restaurantId],
    );
  }

  Future<List<Map<String, Object?>>> getRestaurantsPreferees(String email) async {
    return await db.query(
      'restaurants_preferees',
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
