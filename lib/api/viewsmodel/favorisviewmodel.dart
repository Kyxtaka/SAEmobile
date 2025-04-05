

import 'package:flutter/cupertino.dart';
import 'package:saemobile/api/restaurantapi.dart';
import 'package:saemobile/services/local/tables/restaurantsPrefereesTable.dart';
import '../../models/restaurant.dart';

class FavorisViewModel extends ChangeNotifier {
  late List<Restaurant> favoris = [];

  FavorisViewModel() {
    favoris = [];
  }
  Future<void> generateFavoris(user) async {
    favoris = await RestaurantsPrefereesDAO.getRestaurantsPreferees(user);
    for (var i = 0;i<favoris.length; i++) {
      favoris[i] = (await RestaurantAPI.getRestaurantById(favoris[i].id))!;
    }
    notifyListeners();
  }
  Future<void> removeFavoris(user, fav) async {
    await RestaurantsPrefereesDAO.deleteRestaurantPrefere(user, fav);
    await generateFavoris(user);
    notifyListeners();
  }

  Future<void> addFavoris(user, fav) async {
    await RestaurantsPrefereesDAO.insertRestaurantPrefere(user, fav);
    await generateFavoris(user);
    notifyListeners();
  }

  Future<bool> isFavoris(int fav) async {
    debugPrint("Fav check id ${fav.toString()}");
    debugPrint("check int and string same value ${1 == "1"}");
    for (var i = 0;i<favoris.length;i++){
      debugPrint("it rest id: ${favoris[i].id}");
      debugPrint("check: ${favoris[i].id == fav}");
      if (favoris[i].id==fav){
        return true;
      }
    }
    return false;
  }



}