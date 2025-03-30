

import 'dart:io';

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
                  row['Visiteur']['mail'], "", row['Visiteur']['nom_user'], row['Visiteur']["prenom"], "Visiteur", [], false, ""),
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
                new visiteur.User(row['mail'], "", row['nom_user'], row["prenom"],"Visiteur", [],false, ""),
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
      if (result.isNotEmpty){
        return new Critique(
            result['id_critique'],
            result['message'],
            new Restaurant(result['id_resto'], "", "", 0, "", "", "", "", -1, 45, 0, "", 0.0, 0.0),
            new visiteur.User(result['mail_user'],"","", "", "Visiteur", [], false, ""), "", 3);
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
                new visiteur.User(row['mail_user'], "", "", "","Visiteur", [],false, ""),
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
      if (result != null){
          debugPrint("Error while deleting critique");
          return false;
      }
      else {
        return true;
      }
    } catch (error){
      debugPrint("Error with database: $error ❌");
      return false;
    }
  }
  
  static Future<bool> modifyCritique(id, message, etoiles) async {
    try{
      final result = await Supabase.instance.client
          .from('Critique')
          .update({"message": message, "etoiles": etoiles.round()})
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
  }

  // Ajoute une image d'un commentaire à la BD
  static Future<bool> ajoutePhotoCommentaire(String idCritique, String username, File photo) async {

    final fileName = DateTime.now().microsecondsSinceEpoch.toString();

    final path = "uploads/$fileName";
    final supabase = Supabase.instance.client;


    final response =
    await supabase // Gère automatiquement l'id de la photo gràce à l'option is identity mise sur la colone dans supabase
        .from('photo_critique')
        .insert({
      'user_identifier': username,
      'review_id': idCritique,
      'photoid': path
    }).select();


    await Supabase.instance.client.storage
        .from("imgstorqge")
        .upload(path, photo!)
        .then((value) {
      print("Image bien uploadée : $value");
    }).catchError((error) {
      print("Erreur lors de l'upload : $error");
      return false;
    });
    return response.isNotEmpty;

  }


  static Future<bool> insertCritique( String id_resto, String username, String commentaire, int note) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
      .from('Critique')
      .insert({
        'message': commentaire,
        'mail_user': username,
        'id_resto': id_resto,
        'etoiles': note
    }).catchError((error) {
      print("Erreur lors de l'upload : $error");
      return false;
    });
    return true;
  }

  static Future<bool> insertCommentairePhoto(
    String username, String id_resto, String id_critique, String commentaire, int note, File? image) async {

    // ajouter le comm basique
    bool addcomment = await CritiqueAPI.insertCritique(id_resto, username, commentaire, note);

    // verif comm basique
    if(!addcomment){
      return false;
    }

    await ajoutePhotoCommentaire(id_critique,username, image! );

    return true;
  }
}
