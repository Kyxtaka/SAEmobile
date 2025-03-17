import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/bouton.dart';
import 'package:saemobile/api/restaurantapi.dart';

class Decouverte extends StatelessWidget{
  static Header header = new Header();
  final RestaurantAPI restaurantAPI = new RestaurantAPI();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header.create(),
        body: Center(
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              Text("Les restaurants d'Orléans dans votre poche !"),
              BoutonDegrade(
                text: "Se connecter",
                onPressed: () {
                  print("Bouton pressé !");
                  restaurantAPI.getAllRestaurants();
                },
              )
            ],
          ),
        ));
  }
}