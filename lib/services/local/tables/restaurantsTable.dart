import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../models/restaurant.dart';
import '../sqlfliteDatabase.dart';

class RestaurantsTable {

  Future<void> insertRestaurant(Restaurant restaurant) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.insert(
      'restaurants',
      restaurant.toMapLocal(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateRestaurant(Restaurant restaurant) async {
    final db = await SqlfliteDatabase.instance.database;
    await db.update(
      'restaurants',
      restaurant.toMapLocal(),
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

  static Future<Restaurant> getRestaurantById(int id) async {
    final db = await SqlfliteDatabase.instance.database;
    final List<Map<String, Object?>> Restmaps = await db.query(
      'restaurants',
      where: 'id = ?',
      whereArgs: [id],
    );
    final map = Restmaps.first;
    final capacity = (map['capacity'] as int?) ?? 0;
    final tel = (map['tel'] as String?) ?? '';
    final siret = (map['siret'] as String?) ?? '';
    final website = (map['website'] as String?) ?? '';
    final urlPhoto = (map['url_photo'] as String?) ?? '';
    final idCuisine = (map['id_cuisine'] as int?) ?? 0;
    final idRegion = (map['id_region'] as int?) ?? 0;
    final nbEtoile = (map['nb_etoile'] as int?) ?? 0;
    final horaires = (map['horaires'] as String?) ?? '';
    final gpsLat = (map['gps_lat'] as double?) ?? 0.0;
    final gpsLong = (map['gps_long'] as double?) ?? 0.0;

    Restaurant resto = Restaurant(
      map['id'] as int,
      map['name'] as String,
      map['address'] as String,
      capacity,
      tel,
      siret,
      website,
      urlPhoto,
      idCuisine,
      idRegion,
      nbEtoile,
      horaires,
      gpsLat,
      gpsLong,
    );
    print("restaurant par id $resto");
    return resto;
  }

}
