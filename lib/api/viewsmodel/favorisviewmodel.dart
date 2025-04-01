

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
    favoris = await RestaurantsPreferees.getRestaurantsPreferees(user);
    for (var i = 0;i<favoris.length; i++) {
      favoris[i] = (await RestaurantAPI.getRestaurantById(favoris[i].id))!;
    }
    notifyListeners();
  }
  Future<void> removeFavoris(user, fav) async {
    await RestaurantsPreferees.deleteRestaurantPrefere(user, fav);
    await generateFavoris(user);
    notifyListeners();
  }

  Future<void> addFavoris(user, fav) async {
    await RestaurantsPreferees.insertRestaurantPrefere(user, fav);
    await generateFavoris(user);
    notifyListeners();
  }

  Future<bool> isFavoris(fav) async {
    for (var i = 0;i<favoris.length;i++){
      if (favoris[i].id==fav){
        return true;
      }
    }
    return false;
  }



}