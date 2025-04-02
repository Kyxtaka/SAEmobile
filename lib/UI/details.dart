import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/api/viewsmodel/favorisviewmodel.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:saemobile/services/local/tables/restaurantsPrefereesTable.dart';
import '../api/carateristiqueandcuisineapi.dart';
import '../models/typeCuisine.dart';
import 'global/footer.dart';
import '../api/restaurantapi.dart';
import '../models/restaurant.dart';
import 'global/header.dart';

// Ajouter ce script à l'accueil pour envoyer l'id du restaurant cliqué à DetailsPage
//Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => DetailsPage(restaurantId: restaurant.id_resto),
//   ),
// );

class DetailsPage extends StatefulWidget {
  final String? restaurantId;

  const DetailsPage({required this.restaurantId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  RestaurantAPI api = RestaurantAPI();

  Future<Map<String, dynamic>> getDetailsRestaurant() async {
    var api = RestaurantAPI();
    var restaurant = await RestaurantAPI.getRestaurantById(int.parse(widget.restaurantId??"-1"));
    var type;
    try {
      type = await CaracteristiqueAndCuisineAPI.getType(restaurant?.id_cuisine ?? 0) ?? "Non renseigné";
    } catch (e) {
      type = "Non renseigné";
    }
    return {"restaurant": restaurant, "typecuisine": type};
  }


  @override
  Widget build(BuildContext context) {
    Footer footer = Footer();
    final favorisViewModel = context.watch<FavorisViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: footer.create(context),
      appBar: Header.create(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getDetailsRestaurant(),
          builder: (context, snapshot){
          var typecuisine = "Non renseigné";
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
            else if (snapshot.hasError) {
              return Text("${snapshot.error}");
          } else if (snapshot.hasData) {
            if (snapshot.data!['typecuisine'] is TypeCuisine?){
              typecuisine = snapshot.data!['typecuisine'].cuisine;
            }
              return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Text(
                      snapshot.data!['restaurant'].name,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                  ),
                  Divider(
                    color: Colors.orange,
                    thickness: 2,
                    indent: 250,
                    endIndent: 250,
                  ),
                  SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          snapshot.data!['restaurant'].url_photo,
                          width: 300,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                'assets/img/default-image.png',
                                width: 300,
                                height: 250,
                              ),
                        ),
                      ),
                      Container(
                        width: 120,
                        padding: EdgeInsets.all(5),
                        color: Colors.black54,
                        child: Text(
                          snapshot.data!['restaurant'].name,
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        infoSection("Adresse", snapshot.data!['restaurant'].address),
                        infoSection("Origine", "Type : ${typecuisine}"),
                        infoSection("Capacité", (snapshot.data!['restaurant'].capacity == 0 || snapshot.data!['restaurant'].capacity == -1) ? "Non renseigné" : "${snapshot.data!['restaurant'].capacity} personnes"),
                        infoSection("Contact", (snapshot.data!['restaurant'].tel == "None")?"Non renseigné": "${snapshot.data!['restaurant'].tel}"),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Text("Ajouter en favoris", style: TextStyle(fontSize:15)),
                  IconButton(
                    icon: Icon(Icons.favorite,),
                    color: Colors.grey,
                    onPressed:() async {
                      var user = await  UserViewModel.getCurrentUser();
                      favorisViewModel.addFavoris(user, snapshot.data?['restaurant'].id);
                      context.go('/favoris');}
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                    onPressed: () {
                      context.go('/details/'+snapshot.data!['restaurant'].id.toString()+'/avis');
                    },
                    child: Text("Les Avis", style: TextStyle(color: Colors.white)),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                    onPressed: () {
                      context.go('/details/${widget.restaurantId}/addcritique');
                    },
                    child: Text("Donner un avis", style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          );}
            return Text("Erreur lors de la récupération du restaurant");},

        ));
      }

  Widget infoSection(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
      ],
    );
  }
}





