

import 'package:saemobile/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:saemobile/api/restaurantapi.dart';
import 'package:saemobile/models/restaurant.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/restaurant.dart';
import '../sqlfliteDatabase.dart';
import 'package:saemobile/services/local/tables/restaurantsTable.dart';

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
  }

  static Future<List<Restaurant>> getRestaurantsPreferees(String email) async {
    final db = await SqlfliteDatabase.instance.database;
    var result = await db.query(
      'restaurants_preferees',
      where: 'email = ?',
      whereArgs: [email],
    );
    List<Restaurant> restaurants = [];
    for (var i =0;i<result.length;i++){
      var restaurant = result[i];
      Restaurant? rest = await RestaurantAPI.getRestaurantById(int.parse(restaurant['restaurant_id'].toString()));
      restaurants.add(rest!);
    }
    return restaurants;
  }

}
