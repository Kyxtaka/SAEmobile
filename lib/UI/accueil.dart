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
  static TypeCuisineTable cuisineTable = new TypeCuisineTable();
  RestaurantAPI apiRestaurant = RestaurantAPI(database: Supabase.instance.client);

  @override
  Widget build(BuildContext context) {
    Footer footer = new Footer();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: header.create(),
        bottomNavigationBar: footer.create(context),
        body:
        Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              barreRecherche,
              const SizedBox(height: 16),
              Expanded(
              child: FutureBuilder<List<Restaurant>>(
                future: apiRestaurant.getAllRestaurants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  if (snapshot.hasData) {
                    final restaurants = snapshot.data!;
                    final first5 = restaurants.length >= 5 ? restaurants.sublist(0, 5) : restaurants;
                    return ListView.builder(
                      itemCount: first5.length,
                      itemBuilder: (context, index) {
                        final restaurant = first5[index];
                        return ListTile(
                          title: Text(restaurant.name),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
              )
            ],
        )
    )
    );
  }
}
