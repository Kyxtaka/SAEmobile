
import 'package:flutter/material.dart';
import 'package:saemobile/models/restaurant.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlfliteDatabase.dart';

class RestaurantsPrefereesDAO {

  static Future<void> insertRestaurantPrefere(String email, int restaurantId) async {
    final db = await SqlfliteDatabase.instance.database;
    debugPrint("ajout local favoris pour ${email} avec ${restaurantId}");
    var result = await db.insert(
      'restaurants_preferees',
      {
        'email': email,
        'restaurant_id': restaurantId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteRestaurantPrefere(String email, int restaurantId) async {
    final db = await SqlfliteDatabase.instance.database;
    var result = await db.delete(
      'restaurants_preferees',
      where: 'email = ? AND restaurant_id = ?',
      whereArgs: [email, restaurantId],
    );
    debugPrint(result.toString());
  }

  static Future<List<Restaurant>> getRestaurantsPreferees(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    var result = await db.rawQuery('''
    SELECT * FROM restaurants_preferees ''');
    List<Restaurant> restaurants = [];
    debugPrint(result.toString());
    for (var i =0;i<result.length;i++){
      var restaurant = result[i];
      debugPrint(restaurant.toString());
      restaurants.add(new Restaurant(int.parse(restaurant['restaurant_id'].toString()),
         "",
          "",
          0,
          "",
          "",
          "",
          "",
          0,
          45,
          0,
          "",
          0.0,
          0.0));
    }
    return restaurants;
  }

}
