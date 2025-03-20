import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:saemobile/models/restaurant.dart';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class RestaurantAPI {

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


  Future<List<Restaurant>> getAllRestaurants() async {
    final supabase = await _initDb();
    try {
      final response = await supabase
          .from('Restaurant')
          .select();

      debugPrint("Function executed");
      List<Restaurant> restaurants = [];
      if (response is List) {
        debugPrint("Response contains ${response.length} rows.");
        if (response.isNotEmpty) {
          for (var row in response) {
            //debugPrint("Row: $row");
            //debugPrint("Type of myVar: ${row['siret'].runtimeType}");
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

}