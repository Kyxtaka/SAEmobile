
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

  final SupabaseClient database = Supabase.instance.client;

  RestaurantAPI();

  Restaurant createRestant(Map<String, dynamic> row) {
    return Restaurant(
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
  }

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


  Future<Restaurant?> getRestaurantById(int id) async {
    try {
      final response = await database
          .from('Restaurant')
          .select()
          .eq('id_resto', id)
          .maybeSingle(); // Permet de récupérer un seul élément

      if (response != null) {
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

  Future<List<Restaurant>> getRestaurantByCarac(int caracId) async {
    List<Restaurant> result = [];
    try {
      final responseCaracteriser = await database
          .from('Caracteriser')
          .select('id_resto')
          .eq('id_carac', caracId); // Permet de récupérer un seul élément
      if (responseCaracteriser.isNotEmpty) {
        for (var rowIdResto in responseCaracteriser) {
          Restaurant? rest = await getRestaurantById(int.parse(rowIdResto['id_resto'].toString()));
          if (rest != null) {
            result.add(rest);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching restaurant by ID: $e ❌");
    }
    debugPrint("Pas de restaurant trouvé avec l id carac ${caracId}");
    return result;
  }

  Future<List<Restaurant>> getRestaurantByCuisine(int cuisineId) async {
    List<Restaurant> result = [];
    try {
      final responseCuisine = await database
          .from('Restaurant')
          .select()
          .eq('id_cuisine', cuisineId); // Permet de récupérer un seul élément
      if (responseCuisine.isNotEmpty) {
        for (var resto in responseCuisine) {
          Restaurant rest = createRestant(resto);
          if (rest != null) {
            result.add(rest);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching restaurant by ID: $e ❌");
    }
    debugPrint("Pas de restaurant trouvé avec l id carac ${cuisineId}");
    return result;
  }
}