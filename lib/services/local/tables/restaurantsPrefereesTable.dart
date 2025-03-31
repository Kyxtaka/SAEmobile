

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
        map['id'] as int,
        map['name'] as String,
        map['address'] as String,
        map['capacity'] = 0,
        map['tel'] = '',
        map['siret'] = '',
        map['website'] = '',
        map['url_photo'] = '',
        map['id_cuisine'] = 0,
        map['id_region'] = 0,
        map['nb_etoile'] = 0,
        map['horaires'] = '',
        map['gps_lat'] = 0.0,
        map['gps_long'] = 0.0,
      );
    }).toList();
  }
}
