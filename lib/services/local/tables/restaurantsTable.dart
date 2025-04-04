import 'package:sqflite/sqflite.dart';

import '../../../models/restaurant.dart';

class RestaurantsTable {
  final db;
  RestaurantsTable({required this.db});

  Future<int> insertRestaurant(Restaurant restaurant) async {
    return await db.insert(
      'restaurants',
      restaurant.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateRestaurant(Restaurant restaurant) async {
    return await db.update(
      'restaurants',
      restaurant.toMapLocal(),
      where: 'id = ?',
      whereArgs: [restaurant.id],
    );
  }

  Future<int> deleteRestaurant(int id) async {
    return await db.delete(
      'restaurants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Restaurant>> getAllRestaurants() async {
    final List<Map<String, Object?>> restaurantMaps = await db.query('restaurants');
    return restaurantMaps.map((map) {
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
