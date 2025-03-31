

import 'package:saemobile/models/restaurant.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlfliteDatabase.dart';

class RestaurantsPreferees {

  final Database db;
  RestaurantsPreferees({required this.db});

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

  Future<List<Restaurant>> getRestaurantsPreferees(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    final maps = await db.rawQuery('''
    SELECT r.*
    FROM restaurants_preferees rp
    INNER JOIN restaurants r ON rp.restaurant_id = r.id
    WHERE rp.email = ?
  ''', [email]);
    return maps.map((map) {
      return Restaurant(
        map['id'] as int? ?? 0,
        map['name'] as String? ?? '',
        map['address'] as String? ?? '',
        map['capacity'] as int? ?? 0,
        map['tel'] as String? ?? '',
        map['siret'] as String? ?? '',
        map['website'] as String? ?? '',
        map['url_photo'] as String? ?? '',
        map['id_cuisine'] as int? ?? 0,
        map['id_region'] as int? ?? 0,
        map['nb_etoile'] as int? ?? 0,
        map['horaires'] as String? ?? '',
        map['gps_lat'] as double? ?? 0.0,
        map['gps_long'] as double? ?? 0.0,
      );
    }).toList();
  }
}
