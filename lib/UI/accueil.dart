import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/SearchBar.dart' hide SearchBar;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../api/restaurantapi.dart';
import '../models/restaurant.dart';
import '../services/local/tables/typeCuisineTable.dart';
import '../models/typeCuisine.dart';
import 'global/footer.dart';


class Accueil extends StatefulWidget{
  final SupabaseClient database;
  const Accueil({super.key, required this.database});

  @override
  State<Accueil> createState() => _AccueilState();
}
class _AccueilState extends State<Accueil> {
  static Header header = new Header();
  static SearchBar barreRecherche = new SearchBar();
  final TypeCuisineTable typeCuisineLocal = TypeCuisineTable();
  RestaurantAPI apiRestaurant = RestaurantAPI(database: Supabase.instance.client);

  @override
  void initState() {
    super.initState();
    typeCuisineLocal.insertTypeCuisine(1, TypeCuisine(1, "japonais","./../../assets/img/typeCuisine/japonais.jpg"));
    typeCuisineLocal.insertTypeCuisine(1, TypeCuisine(2, "italien","./../../assets/img/typeCuisine/italien.jpg"));
    typeCuisineLocal.insertTypeCuisine(1, TypeCuisine(3, "coréen","./../../assets/img/typeCuisine/coreen.jpg"));
    typeCuisineLocal.insertTypeCuisine(1, TypeCuisine(4, "français","./../../assets/img/typeCuisine/japonais.jpg"));
    typeCuisineLocal.insertTypeCuisine(1, TypeCuisine(5, "indien","./../../assets/img/typeCuisine/japonais.jpg"));

  }
  @override
  Widget build(BuildContext context) {
    Footer footer = new Footer();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: header.create(),
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
                      future: typeCuisineLocal.getAllTypeCuisines(),
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
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cuisines.length,
                          itemBuilder: (context, index) {
                          final cuisine = cuisines[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(cuisine.img),                                  radius: 24,
                                ),
                              const SizedBox(height: 4),
                              Text(
                                cuisine.cuisine,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
