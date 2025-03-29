import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saemobile/api/viewsmodel/favorisviewmodel.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:saemobile/services/local/tables/restaurantsPrefereesTable.dart';
//import 'global/footer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  RestaurantAPI api = RestaurantAPI(database: Supabase.instance.client);
  bool isFavoris = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavoris();
    });
  }

  Future<void> _loadFavoris() async {
    String userEmail = await UserViewModel.getCurrentUser();
    bool favoris = await RestaurantsPrefereesDAO.isFavoris(
        userEmail, widget.restaurantId);
    setState(() {
      isFavoris = favoris;
    });
  }

  Future<void> _toggleFavoris() async {
    String userEmail = await UserViewModel.getCurrentUser();
    if (isFavoris) {
      await RestaurantsPrefereesDAO.deleteRestaurantPrefere(userEmail, int.parse(widget.restaurantId??"0"));
    } else {
      await RestaurantsPrefereesDAO.insertRestaurantPrefere(userEmail, int.parse(widget.restaurantId??"0"));
    }
    setState(() {
      isFavoris = !isFavoris;
    });
  }

  @override
  Widget build(BuildContext context) {
    Footer footer = Footer();
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: footer.create(context),
      appBar: Header.create(),
      body: FutureBuilder<Restaurant?>(
        future: api.getRestaurantById(int.parse(widget.restaurantId??"-1")),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
          }
            else if (snapshot.hasError) {
              return Text("${snapshot.error}");
          } else if (snapshot.hasData) {
          return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Text(
                      snapshot.data!.name,
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
                          snapshot.data!.url_photo,
                          width: 300,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                '../../assets/img/default-image.png',
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
                          snapshot.data!.name,
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
                        infoSection("Adresse", snapshot.data!.address),
                        infoSection("Origine", "Cuisine ID: ${snapshot.data!.id_cuisine}"),
                        infoSection("Capacité", "${snapshot.data!.capacity} personnes"),
                        infoSection("Contact", snapshot.data!.tel),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  IconButton(
                    icon: Icon(
                      isFavoris ? Icons.favorite : Icons.favorite_border,
                      color: isFavoris ? Colors.red : Colors.grey,
                    ),
                    onPressed: _toggleFavoris,
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
                      context.go('/details/'+snapshot.data!.id.toString()+'/avis');
                    },
                    child: Text("Les Avis", style: TextStyle(color: Colors.white)),
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





