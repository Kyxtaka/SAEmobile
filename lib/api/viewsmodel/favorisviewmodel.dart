

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
    notifyListeners();
  }
  Future<void> removeFavoris(user, fav) async {
    await RestaurantsPrefereesDAO.deleteRestaurantPrefere(user, fav);
    favoris = List.from(favoris)..remove(fav);
    notifyListeners();
  }

  Future<void> addFavoris(user, fav) async {
    await RestaurantsPrefereesDAO.insertRestaurantPrefere(user, fav);
    generateFavoris(user);
    notifyListeners();
  }



}