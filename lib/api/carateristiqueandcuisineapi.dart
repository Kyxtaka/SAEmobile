import 'package:flutter/material.dart';
import 'package:saemobile/models/caracteristique.dart';
import 'package:saemobile/models/restaurant.dart';
import 'package:saemobile/models/typeCuisine.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class CaracteristiqueAndCuisineAPI {
  final SupabaseClient database;

  const CaracteristiqueAndCuisineAPI({required this.database});

  Future<List<Caracteristique>> getAllCaracterisque() async{
    List<Caracteristique> result = [];
    try {
      final response = await database
          .from('Caractéristique')
          .select();
      if (response.isNotEmpty) {
        // debugPrint("Raw response from Supabase: ${response.toString()}");
        for (var row in response) {
          int id = row['id_carac'] is int ? row['id_carac'] : int.parse(row['id_carac'].toString());
          Caracteristique carac = Caracteristique(id, row['carac']);
          result.add(carac);
        }
        debugPrint('all caracteristique added to the List');
      }else if (response.isEmpty) {
        debugPrint("Caracteristique result is empty");
      }
    }catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<List<TypeCuisine>> getAllTypeCuisine() async{
    List<TypeCuisine> result = [];
    try {
      final response = await database
          .from('TypeCuisine')
          .select();
      if (response.isNotEmpty) {

        for (var row in response) {
          int id = row['id'] is int ? row['id'] : int.parse(row['id'].toString());
          TypeCuisine typeCuisine = TypeCuisine(id, row['cuisine']);
          result.add(typeCuisine);
        }
        debugPrint('all type cuisine added to the List');
      }else if (response.isEmpty) {
        debugPrint("Type cuisine result is empty");
      }
    }catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }


}