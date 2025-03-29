
import 'package:flutter/material.dart';
import 'package:saemobile/models/restaurant.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/*
  Future<SupabaseClient> _initDb() async {

    try {
      await dotenv.load(fileName: ".env");
      await Supabase.initialize(
          url: dotenv.env['SUPABASE_DB_API_URL']??'',
          anonKey: dotenv.env['SUPABASE_ANON_KEY']??''
      );
      return Supabase.instance.client;
    } catch (e) {
      debugPrint("supabase and are already initialized");
      return Supabase.instance.client;
    }
  }
  */

class RestaurantAPI {

  final SupabaseClient database;

  const RestaurantAPI({required this.database});

  Future<List<Restaurant>> getAllRestaurants() async {
    //final supabase = await _initDb();
    try {
      final response = await this.database
          .from('Restaurant')
          .select();

      debugPrint("Function executed");
      List<Restaurant> restaurants = [];
      if (response is List) {
        debugPrint("Response contains ${response.length} rows.");
        if (response.isNotEmpty) {
          for (var row in response) {
            Restaurant restaurant = new Restaurant(
                row['id_resto'],
                row['nom']??'None',
                row['adresse']??'None',
                row['capacity']??-1,
                row['tel']??'None',
                row['siret']??'None',
                row['website']??'None',
                row['photo']??'None',
                row['id_cuisine']??-1,
                row['id_region']??-1,
                row['nb_etoile']??-1,
                row['horaires']??'None',
                row['gps_lat']??0.0,
                row['gps_long']??0.0
            );
            //restaurant.debugPrint();
            restaurants.add(restaurant);
          }
          debugPrint("Restaurants count: ${restaurants.length}");
        } else {
          debugPrint("Response is a List, but it's EMPTY! ❌");
        }
      } else {
        debugPrint("Unexpected response type: ${response.runtimeType} ❌");
      }
      return restaurants;
    } catch (e) {
      debugPrint("Error fetching data: $e ❌");
      return [];
    }
  }


  static Future<Restaurant?> getRestaurantById(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('Restaurant')
          .select()
          .eq('id_resto', id)
          .single(); // Permet de récupérer un seul élément

      if (response.isNotEmpty) {
        return Restaurant(
          response['id_resto'],
          response['nom'] ?? 'None',
          response['adresse'] ?? 'None',
          response['capacity'] ?? -1,
          response['tel'] ?? 'None',
          response['siret'] ?? 'None',
          response['website'] ?? 'None',
          response['photo'] ?? 'None',
          response['id_cuisine'] ?? -1,
          response['id_region'] ?? -1,
          response['nb_etoile'] ?? -1,
          response['horaires'] ?? 'None',
          response['gps_lat'] ?? 0.0,
          response['gps_long'] ?? 0.0,
        );
      }
    } catch (e) {
      debugPrint("Error fetching restaurant by ID: $e ❌");
    }
    debugPrint("Pas de restaurant trouvé $id");
    return null;
  }
}