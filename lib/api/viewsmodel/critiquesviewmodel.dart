import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:saemobile/models/critique.dart';


class CritiqueViewModel extends ChangeNotifier{
  late List<Critique> liste = [];
  var _onLoading = true;

  CritiqueViewModel() {
    liste = [];
  }


  get onLoading => _onLoading;

  Future<void> generateCritiques(user) async {
    _onLoading = true;
    notifyListeners();
    print("============================critique get user : $user ============================critique get user : ");
    liste = await CritiqueAPI.getCritiqueForUser(user);
    for (var i = 0;i<liste.length; i++) {
      liste[i] = (await CritiqueAPI.getCritique(liste[i].id))!;
      await liste[i].getCritiqueImageIfExist();
    }
    _onLoading = false;
    notifyListeners();
  }

  Future<void> refreshDataNoNotify() async {
    String username = await UserViewModel.getCurrentUser();
    _onLoading = true;
    liste = await CritiqueAPI.getCritiqueForUser(username);
    for (var i = 0;i<liste.length; i++) {
      liste[i] = (await CritiqueAPI.getCritique(liste[i].id))!;
      await liste[i].getCritiqueImageIfExist();
    }
    _onLoading = false;
    debugPrint("getting critique data again finished");
  }

  Future<bool> deleteCritique(Critique critique, bool imagePresent) async {
    bool isDeleted;
    if (imagePresent) {
      isDeleted = await CritiqueAPI.deleteCritiquePhoto(critique);
    }
    else {
      isDeleted = await CritiqueAPI.deleteCritique(critique);
    }
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

  Future<bool> insertCritique(String idResto, String username, String commentaire, int note) async {
    try {
      Critique? critique = await CritiqueAPI.insertCritique(idResto, username, commentaire, note);
      if (critique != null) {
        await generateCritiques(username);
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
        await generateCritiques(username);
        return critique;
      }
    }catch (e) {
      debugPrint('message erreur ${e.toString()}');
    }
    print('====================================================notyfyListeners==================================');
    return null;
  }
}
