import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/SearchBar.dart' hide SearchBar;
import 'package:saemobile/services/local/tables/restaurantsTable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../api/restaurantapi.dart';
import '../api/typeCuisineapi.dart';
import '../api/viewsmodel/userviewmodel.dart';
import '../models/restaurant.dart';
import '../services/local/tables/cuisinePrefereesTable.dart';
import '../services/local/tables/restaurantsPrefereesTable.dart';
import '../services/local/tables/typeCuisineTable.dart';
import '../models/typeCuisine.dart';
import 'details.dart';
import 'global/footer.dart';
import 'package:saemobile/services/local/tables/restaurantsPrefereesTable.dart';


class Accueil extends StatefulWidget{
  final SupabaseClient database;
  const Accueil({super.key, required this.database});

  @override
  State<Accueil> createState() => _AccueilState();
}
class _AccueilState extends State<Accueil> {

  static SearchBar barreRecherche = new SearchBar();

  late final TypeCuisineTable typeCuisineLocal;
  late final CuisinesPrefereesTable typeCuisinePref;
  late final RestaurantsPrefereesDAO restaurantPrefLocal;
  late final RestaurantsTable restaurants;

  RestaurantAPI apiRestaurant = RestaurantAPI();
  TypeCuisineAPI typeCuisineAPI = TypeCuisineAPI(
      database: Supabase.instance.client);

  Future<List<Restaurant?>> _getSuggestions(String user) async {
    final favoriteCuisines = await CuisinesPrefereesTable.getCuisinesPrefereesInType(user);
    final favoriteCuisineIds = favoriteCuisines.map((cuisine) => cuisine.id).toList();

    final favoriteRestaurants = await RestaurantsPrefereesDAO.getRestaurantsPreferees(user);
    final favoriteRestaurantIds = favoriteRestaurants.map((resto) => resto.id).toList();

    return await apiRestaurant.getRestaurantSuggestions(
      favoriteCuisineIds,
      favoriteRestaurantIds,
    );
  }

  Future<void> _fetchAndInsertTypeCuisines() async {
    List<TypeCuisine> supaCuisines = await typeCuisineAPI.getAllTypeCuisines();
    for (var cuisine in supaCuisines.take(6)) {
      await typeCuisineLocal.insertTypeCuisine(1, cuisine);
    }
  }

  @override
  void initState() {
    super.initState();

    typeCuisineLocal = TypeCuisineTable();
    typeCuisinePref = CuisinesPrefereesTable();
    restaurantPrefLocal = RestaurantsPrefereesDAO();
    restaurants = RestaurantsTable();

    typeCuisineLocal.getAllTypeCuisines().then((localCuisines) {
      if (localCuisines.isEmpty) {
        _fetchAndInsertTypeCuisines();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Footer footer = Footer();
    return FutureBuilder<String>(
      future: UserViewModel.getCurrentUser(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (userSnapshot.hasError) {
          return Text('Erreur utilisateur : ${userSnapshot.error}');
        }

        final user = userSnapshot.data!;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: Header.create(),
          bottomNavigationBar: footer.create(context),
          body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          print("Barre de recherche cliquée");
                          context.go('/search?focus=true');
                        },
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Text(
                                "Rechercher...",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<List<TypeCuisine>>(
                        future: CuisinesPrefereesTable.getCuisinesPrefereesInType(user),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData && snapshot.connectionState !=
                              ConnectionState.done) {
                            return const Center(
                                child: CircularProgressIndicator());
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
                                  child: InkWell(
                                    onTap: () {
                                      context.go('/search?focus=true&cuisine=${cuisine.id}&autoSearch=true');
                                    },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1.0),
                                          borderRadius: BorderRadius.circular(
                                              12.0),
                                          image: DecorationImage(
                                            image: cuisine.img == 'None'
                                                ? AssetImage(
                                                'assets/img/typeCuisine/defaut.jpeg')
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
                                )
                                );
                              },
                            ),
                          );
                        },
                      ),
                      FutureBuilder<List<Restaurant?>>(
                        future: RestaurantsPrefereesDAO.getRestaurantsPreferees(
                            user),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData && snapshot.connectionState !=
                              ConnectionState.done) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text('Erreur : ${snapshot.error}');
                          }
                          final restaurantPref = snapshot.data ?? [];
                          print(restaurantPref);
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
                                    final Restaurant? resto = restaurantPref[index];
                                    print(resto?.debugPrint());
                                    print(resto?.url_photo);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: 12.0),
                                      child: InkWell(
                                          onTap: () {
                                            context.go('/details/${resto?.id.toString()}');
                                          },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Container(width: 140, height: 140,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(12),
                                              image: DecorationImage(
                                                image: resto?.url_photo == 'None'
                                                    ? AssetImage(
                                                    'assets/img/default-image.png')
                                                    : AssetImage(resto!.url_photo),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                // Fond sombre dégradé
                                                Positioned(
                                                  bottom: 0, left: 0, right: 0,
                                                  child: Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius
                                                          .only(
                                                        bottomLeft: Radius
                                                            .circular(12),
                                                        bottomRight: Radius
                                                            .circular(12),
                                                      ),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.black
                                                              .withOpacity(0.7),
                                                          Colors.transparent
                                                        ],
                                                        begin: Alignment
                                                            .bottomCenter,
                                                        end: Alignment
                                                            .topCenter,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // Nom du restaurant
                                                Positioned(
                                                  bottom: 8, left: 8, right: 8,
                                                  child: Text(
                                                    resto?.name ?? '',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 14,
                                                      shadows: [
                                                        Shadow(
                                                          offset: Offset(0, 1),
                                                          blurRadius: 2,
                                                          color: Colors.black,
                                                        )
                                                      ],
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),)
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                      FutureBuilder<List<Restaurant?>>(
                        future: _getSuggestions(user),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text('Erreur suggestions : ${snapshot.error}');
                          }
                          final suggestions = snapshot.data ?? [];
                          print("suggestions: $suggestions");
                          if (suggestions.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Nos suggestions du moment",
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
                                  itemCount: suggestions.length,
                                  itemBuilder: (context, index) {
                                    final resto = suggestions[index];
                                    print(resto);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12.0),
                                      child: InkWell(
                                          onTap: () {
                                            context.go('/details/${resto.id.toString()}');
                                          },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 140,
                                            height: 140,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              image: DecorationImage(
                                                image: (resto?.url_photo == 'None')
                                                    ? const AssetImage('assets/img/default-image.png')
                                                    : AssetImage(resto!.url_photo),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.only(
                                                        bottomLeft: Radius.circular(12),
                                                        bottomRight: Radius.circular(12),
                                                      ),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.black.withOpacity(0.7),
                                                          Colors.transparent,
                                                        ],
                                                        begin: Alignment.bottomCenter,
                                                        end: Alignment.topCenter,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // Nom du restaurant
                                                Positioned(
                                                  bottom: 8,
                                                  left: 8,
                                                  right: 8,
                                                  child: Text(
                                                    resto!.name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      shadows: [
                                                        Shadow(
                                                          offset: Offset(0, 1),
                                                          blurRadius: 2,
                                                          color: Colors.black,
                                                        )
                                                      ],
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
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
      },
    );
  }

}
