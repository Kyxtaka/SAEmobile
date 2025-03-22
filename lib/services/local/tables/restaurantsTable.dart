import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../models/restaurant.dart';
import '../sqlfliteDatabase.dart';

class RestaurantsTable {

  Future<void> insertRestaurant(Restaurant restaurant) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.insert(
      'restaurants',
      restaurant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateRestaurant(Restaurant restaurant) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.update(
      'restaurants',
      restaurant.toMap(),
      where: 'id = ?',
      whereArgs: [restaurant.id],
    );
  }

  Future<void> deleteRestaurant(int id) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.delete(
      'restaurants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Restaurant>> getAllRestaurants() async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, Object?>> restaurantMaps = await db.query('restaurants');
    return restaurantMaps.map((map) {
      return Restaurant(
        map['id'] as int,
        map['name'] as String,
        map['address'] as String,
        map['capacity'] as int,
        map['tel'] as String,
        map['siret'] as String,
        map['website'] as String,
        map['url_photo'] as String,
        map['id_cuisine'] as int,
        map['id_region'] as int,
        map['nb_etoile'] as int,
        map['horaires'] as String,
        map['gps_lat'] as double,
        map['gps_long'] as double,
      );
    }).toList();
  }
}
