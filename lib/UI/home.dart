

import 'package:flutter/material.dart';
import 'package:saemobile/UI/themes/bouton.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children:[
            Text("Les restaurants d'Orléans dans votre poche !"),
            BoutonDegrade(
              text: "Se connecter",
              onPressed: () {
                print("Bouton pressé !");
              },
            )
    ],
      ),
    ));
  }
}