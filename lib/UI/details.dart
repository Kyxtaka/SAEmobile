import 'package:flutter/material.dart';
//import 'global/footer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'global/footer.dart';
import '../api/restaurantapi.dart';
import '../models/restaurant.dart';

// Ajouter ce script à l'accueil pour envoyer l'id du restaurant cliqué à DetailsPage
//Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => DetailsPage(restaurantId: restaurant.id_resto),
//   ),
// );

class DetailsPage extends StatefulWidget {
  final int restaurantId;

  const DetailsPage({required this.restaurantId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  RestaurantAPI api = RestaurantAPI(database: Supabase.instance.client);
  Restaurant? restaurant;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRestaurant();
  }

  Future<void> fetchRestaurant() async {
    Restaurant? data = await api.getRestaurantById(widget.restaurantId);
    setState(() {
      restaurant = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Footer footer = Footer();
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: footer.create(context),
      appBar: AppBar(
        backgroundColor: Colors.orange.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Détails",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Chargement
          : restaurant == null
          ? Center(child: Text("Restaurant non trouvé ❌"))
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Text(
                restaurant!.name,
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
                    restaurant!.url_photo,
                    width: 300,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(
                          '../../assets/img/default_image.png',
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
                    restaurant!.name,
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
                  infoSection("Adresse", restaurant!.address),
                  infoSection("Origine", "Cuisine ID: ${restaurant!.id_cuisine}"),
                  infoSection("Capacité", "${restaurant!.capacity} personnes"),
                  infoSection("Contact", restaurant!.tel),
                ],
              ),
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
                // Ajouter navigation vers page Avis
              },
              child: Text("Les Avis", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
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





