
import 'package:flutter/material.dart';
import 'package:saemobile/models/restaurant.dart';
import 'package:saemobile/models/user.dart' as visiteur;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/critique.dart';

class CritiqueAPI {

  /// recupere toutes les critiques d'un restaurant
  static Future<List<Critique>> getCritiquesForRestaurant(id) async {
    try {
      final response = await Supabase.instance.client
          .from('Critique')
          .select('*, Visiteur(mail, prenom, nom_user)')
          .eq('id_resto', id);
      List<Critique> critiques = [];
      debugPrint("Response contains ${response.length} rows.");
      if (response.isNotEmpty) {
        for (var row in response) {
          Critique critique = new Critique(
              row['id_critique'],
              row['message'] ?? "",
              new Restaurant(row['id_resto'], "", "", 0, "", "", "", "", -1, 45, 0, "", 0.0, 0.0),
              new visiteur.User(
                  mail: row['Visiteur']['mail'],
                  password: "",
                  nom: row['Visiteur']['nom_user'],
                  prenom: row['Visiteur']["prenom"],
                  role: "Visiteur",
                  tester: [],
                  connected: false,
                  localisation: ""
              ),
              row['date_test'] ?? "No date",
              row['etoiles'] ?? 3
          );
          //restaurant.debugPrint();
          critiques.add(critique);
        }
      }
      return critiques;
    } catch (error){
      debugPrint("Error fetching data: $error ❌");
      return [];
    }
  }
  /// recupere toutes les critiques en base de donnees
  static Future<List<Critique>> getCritiques() async{
    try {
      final response = await Supabase.instance.client
          .from('Critique')
          .select('*, Restaurant(id_resto, adresse, nom), Visiteur(mail, prenom, nom_user)');
      List<Critique> critiques = [];
      if (response is List) {
        debugPrint("Response contains ${response.length} rows.");
        if (response.isNotEmpty) {
          for (var row in response) {
            Critique critique = new Critique(
                row['id_critique'],
                row['message']??"",
                new Restaurant(row['id_resto'], row['Restaurant']['nom'], row['Restaurant']['adresse'], 0, "", "", "", "", -1, 45, 0, "", 0.0, 0.0),
                new visiteur.User(
                    mail: row['Visiteur']['mail'],
                    password: "",
                    nom: row['Visiteur']['nom_user'],
                    prenom: row['Visiteur']["prenom"],
                    role: "Visiteur",
                    tester: [],
                    connected: false,
                    localisation: ""
                ),
                row['date_test']??"No date",
                row['etoiles']??3
            );
            //restaurant.debugPrint();
            critiques.add(critique);
          }
        } else {
          debugPrint("Response is a List, but it's EMPTY! ❌");
        }
      } else {
        debugPrint("Unexpected response type: ${response.runtimeType} ❌");
      }
      return critiques;
    } catch (e) {
      debugPrint("Error fetching data: $e ❌");
      return [];
    }
  }

  static Future<Critique?> getCritique(id) async {
    try{
      final result = await Supabase.instance.client
          .from("Critique")
          .select('*')
          .eq('id_critique', id)
          .single();
      if (result != null) {
        return new Critique(
            result['id_critique'],
            result['message'],
            new Restaurant(result['id_resto'], "", "", 0, "", "", "", "", -1, 45, 0, "", 0.0, 0.0),
            new visiteur.User(
                mail: result['Visiteur']['mail'],
                password: "",
                nom: result['Visiteur']['nom_user'],
                prenom: result['Visiteur']["prenom"],
                role: "Visiteur",
                tester: [],
                connected: false,
                localisation: ""
            ), "", 3);
      }
    } catch (error){
      debugPrint("Error while modify : $error ❌");
      return null;
    }
  }

  /// get les critiques d'un utilisateur
  static Future<List<Critique>> getCritiqueForUser(mail) async{
    try {
      final response = await Supabase.instance.client
          .from('Critique')
          .select('*, Restaurant(id_resto, adresse, nom)')
          .eq('mail_user', mail);
      List<Critique> critiques = [];
      if (response is List) {
        debugPrint("Response contains ${response.length} rows.");
        if (response.isNotEmpty) {
          for (var row in response) {
            Critique critique = new Critique(

                row['id_critique'],
                row['message']??"",
                new Restaurant(row['id_resto'], row['Restaurant']['nom'], row['Restaurant']['adresse'], 0, "", "", "", "", -1, 45, 0, "", 0.0, 0.0),
                new visiteur.User(
                    mail: row['Visiteur']['mail_user'],
                    password: "",
                    nom: row['Visiteur']['nom_user'],
                    prenom: row['Visiteur']["prenom"],
                    role: "Visiteur",
                    tester: [],
                    connected: false,
                    localisation: ""
                ),
                row['date_test']??"No date",
                row['etoiles']??3
            );
            //restaurant.debugPrint();
            critiques.add(critique);
          }
          debugPrint("Critiques count: ${critiques.length}");
        } else {
          debugPrint("Response is a List, but it's EMPTY! ❌");
        }
      } else {
        debugPrint("Unexpected response type: ${response.runtimeType} ❌");
      }
      return critiques;
    } catch (e) {
      debugPrint("Error fetching data: $e ❌");
      return [];
    }
  }

  /// suppression d'une critique
  static Future<bool> deleteCritique(critique) async {
    try {
      final result = await Supabase.instance.client
          .from('Critique')
          .delete()
          .eq('id_critique', critique.id);

      if (result.isEmpty) {
        return true;
      } else {
        debugPrint("Error while deleting critique ❌");
        return false;
      }
    } catch (error) {
      debugPrint("Error with database: $error ❌");
      return false;
    }
  }

  static Future<bool> modifyCritique(id, message, etoiles) async {
    try{
      final result = await Supabase.instance.client
          .from('Critique')
          .update({ "message": message, "etoiles": etoiles.round() })
          .eq('id_critique', id)
          .select();
      if (result.isNotEmpty){
        debugPrint("modify");
        return true;
      }

      return false;
    } catch (error){
      debugPrint("Error while modify : $error ❌");
      return false;
    }
  }}
