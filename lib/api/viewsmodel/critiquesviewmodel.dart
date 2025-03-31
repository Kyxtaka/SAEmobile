import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/models/critique.dart';


class CritiqueViewModel extends ChangeNotifier{
  late List<Critique> liste = [];

  CritiqueViewModel() {
    liste = [];
  }



  Future<void> generateCritiques(user) async {
    print("Avant récupération des critiques");
    final newListe = await CritiqueAPI.getCritiqueForUser(user);
    print("Nouvelles critiques récupérées: $newListe");

    liste = List.from(newListe);
    print("Liste après mise à jour: $liste");

    notifyListeners();
    print("notifyListeners() appelé !");
  }


  Future<bool> deleteCritique(Critique critique) async {
    bool isDeleted = await CritiqueAPI.deleteCritique(critique);
    if (isDeleted) {
      liste = List.from(liste)..remove(critique);
      notifyListeners();
      return true;
    } else {
      debugPrint("La suppression a échoué");
      return false;
    }
  }
  Future<bool> editCritique(id, message, etoiles) async {
    bool isModify = await CritiqueAPI.modifyCritique(id, message, etoiles);
    if (isModify) {
      var elem = liste.firstWhere((i) => i.id == id);
      elem.message = message;
      elem.note = etoiles.round();

      notifyListeners();
      return true;
    } else {
      debugPrint("La modification a échoué");
      return false;
    }
  }

  Future<bool> insertCritique(String id_resto, String username, String commentaire, int note) async {
    try {
      Critique? critique = await CritiqueAPI.insertCritique(id_resto, username, commentaire, note);
      debugPrint("Critique value critique value insert");
      print(critique);
      print("critique is null 1: ${critique == null}");
      if (critique != null) {
        print("critique is null 2: ${critique == null}");
        print("liste before: ${liste}");
        await generateCritiques(username);

        // liste.add(critique); // Ajout immédiat à la liste
        // await generateCritiques(username);
        notifyListeners();
        print("list after notified listeners ${liste}");
        return true;
      }
    } catch (e) {
      debugPrint("La création a échoué : ${e.toString()}");
    }
    return false;
  }


  Future<bool> insertCritiquePhoto(String username, String idResto, String message, int note, File? image) async {
    try {
      await CritiqueAPI.insertCritiquePhoto(username, idResto, message, note, image);
      notifyListeners();
      return true;
    }catch (e) {
      debugPrint('message erreur ${e.toString()}');
    }
    print('====================================================notyfyListeners==================================');
    return false;
  }
}
