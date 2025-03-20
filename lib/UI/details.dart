import 'package:flutter/material.dart';
import 'global/footer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// fonction get le détails d'un restaurant
//Future<Map<String, dynamic>> getRestaurantDetails(int restaurantId) async {
//final response = await Supabase.instance.client
//      .from('RESTAURANT')
//      .select()
//      .eq('id', restaurantId)
//      .single();
//  if (response.error != null) {
//    throw Exception('Erreur lors de la récupération des données');
//  }
//  return response.data;
//}

class Details extends StatelessWidget {
  static Footer header = new Footer(items: [
    BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'Home',
  ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bookmark),
      label: 'Bookmark',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    )],);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DetailsPage(),
    );
  }
}

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orange.shade200,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {},
          ),
          title: Text(
            "Détails",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SizedBox.expand(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  // Centrer le titre principal
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Text(
                      "Un nouvel intérêt ?",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing : 1
                      ),
                    ),
                  ),
                  Divider(
                    color : Colors.orange,
                    thickness: 2,
                    indent: 250,
                    endIndent: 250,
                  ),
                  SizedBox(height: 10),
                  // Image + Overlay Texte
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          '../../assets/img/pizza-orleans.png',
                          width: 300,
                          height: 250,
                        ),
                      ),
                      Container(
                        width: 120,
                        padding: EdgeInsets.all(5),
                        color: Colors.black54,
                        child: Text(
                          "Pizzeria\nOrléans",
                          textAlign: TextAlign.center, // Centrer le texte de l'overlay
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Infos Texte centrés
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Titre centré : "Adresse"
                        Text(
                          "Adresse",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center, // Centrer "Adresse"
                        ),
                        Text(
                          "41 Rue Patrick Sébastien, 45000 Orléans",
                          textAlign: TextAlign.center, // Centrer l'adresse
                        ),
                        SizedBox(height: 8),
                        // Titre centré : "Origine"
                        Text(
                          "Origine",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center, // Centrer "Origine"
                        ),
                        Text(
                          "Italie",
                          textAlign: TextAlign.center, // Centrer "Italie"
                        ),
                        SizedBox(height: 8),
                        // Titre centré : "Inclus"
                        Text(
                          "Inclus",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center, // Centrer "Inclus"
                        ),
                        Text(
                          "Vegetarian",
                          textAlign: TextAlign.center, // Centrer "Vegetarian"
                        ),
                        SizedBox(height: 8),
                        // Titre centré : "Contact"
                        Text(
                          "Contact",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center, // Centrer "Contact"
                        ),
                        Column(
                          children: [
                            Text(
                              "example@gmail.com",
                              textAlign: TextAlign.center, // Centrer l'email
                            ),
                            Text(
                              "02 56 47 22 01",
                              textAlign: TextAlign.center, // Centrer le téléphone
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  // Bouton "Les Avis"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                    onPressed: () {},
                    child: Text("Les Avis", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )));
  }
}
// version adaptée à la base
//class DetailsPage extends StatelessWidget {
//   final int restaurantId; // ID du restaurant passé à la page
//
//   DetailsPage({required this.restaurantId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Détails")),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: getRestaurantDetails(restaurantId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Erreur: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             final restaurant = snapshot.data!;
//             return Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   Text(
//                     restaurant['name'],
//                     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Divider(color: Colors.orange, thickness: 2),
//                   SizedBox(height: 10),
//                   Text('Adresse: ${restaurant['address']}'),
//                   Text('Origine: ${restaurant['origin']}'),
//                   Text('Contact: ${restaurant['contact']}'),
//                   // Ajoutez d'autres informations du restaurant ici
//                 ],
//               ),
//             );
//           } else {
//             return Center(child: Text('Aucune donnée trouvée'));
//           }
//         },
//       ),
//     );
//   }
// }
