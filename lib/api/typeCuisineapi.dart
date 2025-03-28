import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/typeCuisine.dart';

class TypeCuisineAPI {
  final SupabaseClient database;

  const TypeCuisineAPI({required this.database});

  Future<List<TypeCuisine>> getAllTypeCuisines() async {
    try {
      final response = await database.from('TypeCuisine').select();
      List<TypeCuisine> cuisines = [];
      if (response is List) {
        for (var row in response) {
          cuisines.add(
            TypeCuisine(
              row['id_cuisine'] ?? row['id'],
              row['nom_cuisine'] ?? row['nom'],
              null,
            ),
          );
        }
      }
      return cuisines;
    } catch (e) {
      debugPrint("Erreur lors de la récupération des types de cuisine : $e");
      return [];
    }
  }
}
