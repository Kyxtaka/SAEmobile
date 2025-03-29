import 'package:saemobile/models/restaurant.dart';
import 'package:saemobile/services/local/tables/cuisinePrefereesTable.dart';
import 'package:saemobile/services/local/tables/restaurantsPrefereesTable.dart';
import 'package:saemobile/services/local/tables/restaurantsTable.dart';
import 'package:saemobile/services/local/tables/typeCuisineTable.dart';
import 'package:saemobile/services/local/tables/userTable.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/typeCuisine.dart';
import '../../models/user.dart';

final TypeCuisineTable typeCuisineLocal = TypeCuisineTable();
final CuisinesPreferees typeCuisinePref = CuisinesPreferees();
final RestaurantsPreferees restaurantPrefLocal = RestaurantsPreferees();
final RestaurantsTable restaurants = RestaurantsTable();
final UserTable user = UserTable();

Future<void> insertData() async {
  await restaurants.insertRestaurant(
      new Restaurant(
          5139,
          'Cha+',
          '29 rue Sainte-Catherine',
          0,
          '',
          '',
          '',
          '',
          0,
          0,
          0,
          '',
          0.0,
          0.0)
  );

  await restaurants.insertRestaurant(
      new Restaurant(
          5140,
          'Freshkin',
          '7 avenue du général Paton',
          0,
          '',
          '',
          '',
          '',
          0,
          0,
          0,
          '',
          0.0,
          0.0)
  );

  await restaurants.insertRestaurant(
      new Restaurant(
          5142,
          'KFC',
          '1 avenue roger secrétain',
          0,
          '',
          '',
          '',
          '',
          0,
          0,
          0,
          '',
          0.0,
          0.0)
  );

  await restaurantPrefLocal.insertRestaurantPrefere('a@mail.com', 5139);

  await restaurantPrefLocal.insertRestaurantPrefere('a@mail.com', 5140);

  await restaurantPrefLocal.insertRestaurantPrefere('a@mail.com', 5142);

  await typeCuisineLocal.insertTypeCuisine(
      1, TypeCuisine(1, "japonais", "assets/img/typeCuisine/japonais.jpg"));
  await typeCuisineLocal.insertTypeCuisine(
      2, TypeCuisine(2, "italien", "assets/img/typeCuisine/italien.jpg"));
  await typeCuisineLocal.insertTypeCuisine(
      3, TypeCuisine(3, "coréen", "assets/img/typeCuisine/coreen.jpg"));
  await typeCuisineLocal.insertTypeCuisine(
      4, TypeCuisine(4, "français", "assets/img/typeCuisine/japonais.jpg"));
  await typeCuisineLocal.insertTypeCuisine(
      5, TypeCuisine(5, "indien", "assets/img/typeCuisine/japonais.jpg"));

  await typeCuisinePref.insertCuisinePrefere('a@mail.com', 1);
  await typeCuisinePref.insertCuisinePrefere('a@mail.com', 2);
  await typeCuisinePref.insertCuisinePrefere('a@mail.com', 3);
  await typeCuisinePref.insertCuisinePrefere('a@mail.com', 4);
}