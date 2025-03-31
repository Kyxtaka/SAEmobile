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
    liste = await CritiqueAPI.getCritiqueForUser(user);
    for (var i = 0;i<liste.length; i++) {
      liste[i] = (await CritiqueAPI.getCritique(liste[i].id))!;
      await liste[i].getCritiqueImageIfExist();
    }
    notifyListeners();
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
      if (critique != null) {
        await generateCritiques(username);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("La création a échoué : ${e.toString()}");
    }
    return false;
  }


  Future<Critique?> insertCritiquePhoto(String username, String idResto, String message, int note, File? image) async {
    try {
      final critique = await CritiqueAPI.insertCritiquePhoto(username, idResto, message, note, image);
      if (critique != null) {
        critique.getCritiqueImageIfExist();
        liste.add(critique);
        notifyListeners();
        return critique;
      }
    }catch (e) {
      debugPrint('message erreur ${e.toString()}');
    }
    generateCritiques(username);
    notifyListeners();
    print('====================================================notyfyListeners==================================');
    return null;
  }
}
