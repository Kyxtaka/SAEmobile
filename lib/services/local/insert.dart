import 'package:saemobile/services/local/tables/restaurantsPrefereesTable.dart';
import 'package:saemobile/services/local/tables/restaurantsTable.dart';
import 'package:saemobile/services/local/tables/typeCuisineTable.dart';
import 'package:saemobile/services/local/tables/userTable.dart';
import 'package:sqflite/sqflite.dart';

import 'package:saemobile/models/restaurant.dart';
import 'package:saemobile/services/local/tables/cuisinePrefereesTable.dart';
import '../../models/typeCuisine.dart';
import '../../models/user.dart';

class Insert {
  static Future<void> insertData(Database db) async {

    final TypeCuisineTable typeCuisineLocal = TypeCuisineTable();
    final CuisinesPreferees typeCuisinePref = CuisinesPreferees();
    final RestaurantsPreferees restaurantPrefLocal = RestaurantsPreferees();
    final RestaurantsTable restaurants = RestaurantsTable();
    final UserTable user = UserTable();

    await restaurants.insertRestaurant(
      Restaurant(
        5139,
        'Cha+',
        '29 rue Sainte-Catherine',
        0,
        '',
        '',
        '',
        'assets/img/cha.png',
        0,
        0,
        0,
        '',
        0.0,
        0.0,
      ),
    );

    await restaurants.insertRestaurant(
      Restaurant(
        5140,
        'Freshkin',
        '7 avenue du Général Patton',
        0,
        '',
        '',
        '',
        'assets/img/freshkin.png',
        0,
        0,
        0,
        '',
        0.0,
        0.0,
      ),
    );

    await restaurants.insertRestaurant(
      Restaurant(
        5142,
        'KFC',
        '1 avenue Roger Secrétain',
        0,
        '',
        '',
        '',
        'assets/img/kfc.png',
        0,
        0,
        0,
        '',
        0.0,
        0.0,
      ),
    );

    // Insertion de restaurants préférés
    await RestaurantsPreferees.insertRestaurantPrefere('a@mail.com', 5139);
    await RestaurantsPreferees.insertRestaurantPrefere('a@mail.com', 5140);
    await RestaurantsPreferees.insertRestaurantPrefere('a@mail.com', 5142);

    // Insertion de types de cuisine
    await typeCuisineLocal.insertTypeCuisine(
      1,
      TypeCuisine(76, 'tacos', 'assets/img/typeCuisine/japonais.jpg'),
    );
    await typeCuisineLocal.insertTypeCuisine(
      2,
      TypeCuisine(78, 'italian', 'assets/img/typeCuisine/italien.jpg'),
    );
    await typeCuisineLocal.insertTypeCuisine(
      3,
      TypeCuisine(83, 'mexican', 'assets/img/typeCuisine/coreen.jpg'),
    );
    await typeCuisineLocal.insertTypeCuisine(
      4,
      TypeCuisine(91, 'vietnamese', 'assets/img/typeCuisine/francais.png'),
    );
    await typeCuisineLocal.insertTypeCuisine(
      5,
      TypeCuisine(102, 'turkish', 'assets/img/typeCuisine/indien.png'),
    );

    await typeCuisinePref.insertCuisinePrefere('a@mail.com', 76);
    await typeCuisinePref.insertCuisinePrefere('a@mail.com', 78);
    await typeCuisinePref.insertCuisinePrefere('a@mail.com', 83);
    await typeCuisinePref.insertCuisinePrefere('a@mail.com', 91);
    await typeCuisinePref.insertCuisinePrefere('a@mail.com', 102);

  }
}
