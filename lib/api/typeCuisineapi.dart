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
            TypeCuisine typeCuisine = new TypeCuisine(
              row['id'] ?? row['id'] ?? -1,
              row['cuisine'] ?? 'None',
              row['imgCuisine'] ?? 'None'
            );
            cuisines.add(typeCuisine);
        }
      }
      return cuisines;
    } catch (e) {
      debugPrint("Erreur lors de la récupération des types de cuisine : $e");
      return [];
    }
  }
}
