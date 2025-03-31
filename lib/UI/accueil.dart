import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/SearchBar.dart' hide SearchBar;
import 'package:saemobile/services/local/tables/restaurantsTable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../api/restaurantapi.dart';
import '../api/typeCuisineapi.dart';
import '../models/restaurant.dart';
import '../services/local/tables/cuisinePrefereesTable.dart';
import '../services/local/tables/restaurantsPrefereesTable.dart';
import '../services/local/tables/typeCuisineTable.dart';
import '../models/typeCuisine.dart';
import 'global/footer.dart';


class Accueil extends StatefulWidget{
  final SupabaseClient database;
  final Database db; //bd sqlflite
  const Accueil({super.key, required this.database, required this.db});

  @override
  State<Accueil> createState() => _AccueilState();
}
class _AccueilState extends State<Accueil> {

  static SearchBar barreRecherche = new SearchBar();

  late final TypeCuisineTable typeCuisineLocal;
  late final CuisinesPreferees typeCuisinePref;
  late final RestaurantsPreferees restaurantPrefLocal;
  late final RestaurantsTable restaurants;

  RestaurantAPI apiRestaurant = RestaurantAPI(database: Supabase.instance.client);
  TypeCuisineAPI typeCuisineAPI = TypeCuisineAPI(database: Supabase.instance.client);

  Future<void> _fetchAndInsertTypeCuisines() async {
    List<TypeCuisine> supaCuisines = await typeCuisineAPI.getAllTypeCuisines();
    for (var cuisine in supaCuisines.take(5)) {
      await typeCuisineLocal.insertTypeCuisine(1, cuisine);
    }
  }

  @override
  void initState() {
    super.initState();

    typeCuisineLocal = TypeCuisineTable(db: widget.db);
    typeCuisinePref = CuisinesPreferees(db: widget.db);
    restaurantPrefLocal = RestaurantsPreferees(db: widget.db);
    restaurants = RestaurantsTable(db: widget.db);

    typeCuisineLocal.getAllTypeCuisines().then((localCuisines) {
      if (localCuisines.isEmpty) {
        _fetchAndInsertTypeCuisines();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Footer footer = new Footer();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: Header.create(),
        bottomNavigationBar: footer.create(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  barreRecherche,
                  const SizedBox(height: 16),
                    FutureBuilder<List<TypeCuisine>>(
                      future: typeCuisinePref.getCuisinesPreferees('a@mail.com'),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Erreur : ${snapshot.error}');
                      }
                      final cuisines = snapshot.data ?? [];
                      if (cuisines.isEmpty) {
                        return const SizedBox();
                      }
                      return SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cuisines.length,
                          itemBuilder: (context, index) {
                          final cuisine = cuisines[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(12.0),
                                    image: DecorationImage(
                                      image: cuisine.img == 'None'
                                          ? AssetImage('assets/img/typeCuisine/defaut.jpeg')
                                          : AssetImage(cuisine.img),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cuisine.cuisine,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              FutureBuilder<List<Restaurant>>(
                    future: restaurantPrefLocal.getRestaurantsPreferees('a@mail.com'),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Erreur : ${snapshot.error}');
                      }
                      final restaurantPref = snapshot.data ?? [];
                      if (restaurantPref.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Vos restaurants préférés",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: restaurantPref.length,
                              itemBuilder: (context, index) {
                                final Restaurant resto = restaurantPref[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          image: DecorationImage(
                                            image: AssetImage(resto.url_photo ?? 'assets/img/restaurants/defaut.jpg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        resto.name!,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),

              const SizedBox(height: 20),
             ],
              )
          )
        ),
    );
  }
}


