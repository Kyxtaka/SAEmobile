import 'package:flutter/material.dart';

class Details extends StatelessWidget {
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
      body: SizedBox.expand (
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Un nouvel intérêt ?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Image + Overlay Texte
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      "https://source.unsplash.com/200x200/?pizza",
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 120,
                    padding: EdgeInsets.all(5),
                    color: Colors.black54,
                    child: Text(
                      "Pizzeria\nOrléans",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Infos Texte
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Adresse",
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                    Text("41 Rue Patrick Sébastien, 45000 Orléans"),
                    SizedBox(height: 8),
                    Text(
                      "Origine",
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                    Text("Italie"),
                    SizedBox(height: 8),
                    Text(
                      "Inclus",
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                    Text("Vegetarian"),
                    SizedBox(height: 8),
                    Text(
                      "Contact",
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                    Text("example@gmail.com"),
                    Text("02 56 47 22 01"),
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
        ),
      // Barre de Navigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Rechercher"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoris"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
