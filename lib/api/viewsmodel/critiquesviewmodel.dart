import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:saemobile/models/critique.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class CritiqueViewModel extends ChangeNotifier{
  late List<Critique> liste = [];

  CritiqueViewModel() {
    liste = [];
  }
  Future<void> generateCritiques(user) async {
    liste = await CritiqueAPI.getCritiqueForUser(user);
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

  Future<void> insertCritique(String id_resto, String username, String commentaire, int note) async {
    try {
      await CritiqueAPI.insertCritique(id_resto, username, commentaire, note);
    }catch (e) {
      debugPrint("La creation a échoué ${e.toString()}");
    }
    await generateCritiques(username);
    notifyListeners();
  }

  Future<void> insertCritiquePhoto(String username, String idResto, String message, int note, File? image) async {
    try {
      await CritiqueAPI.insertCritiquePhoto(username, idResto, message, note, image);
    }catch (e) {
      debugPrint('message erreur ${e.toString()}');
    }
    await generateCritiques(username);
    notifyListeners();

  }
}
