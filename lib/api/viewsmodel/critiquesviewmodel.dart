import 'package:flutter/material.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/models/critique.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class CritiqueViewModel extends ChangeNotifier{
  late List<Critique> liste = [];
  late CritiqueAPI api;

  CritiqueViewModel.api(this.api){
    this.api = api;
  }
  CritiqueViewModel() {
    liste = [];
  }
  Future<void> generateCritiques(user) async {
    liste = await api.getCritiqueForUser(user);
    notifyListeners();
  }
  Future<bool> deleteCritique(Critique critique) async {
    bool isDeleted = await api.deleteCritique(critique);
    if (isDeleted) {
      liste = List.from(liste)..remove(critique);
      notifyListeners();
      return true;
    } else {
      debugPrint("La suppression a échoué");
      return false;
    }
  }


}
