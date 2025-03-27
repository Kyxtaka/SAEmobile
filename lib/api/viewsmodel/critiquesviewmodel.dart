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
      generateCritiques(UserViewModel.getCurrentUser());
      notifyListeners();
      return true;
    } else {
      debugPrint("La modification a échoué");
      return false;
    }
  }


}
