
import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/bouton.dart';

class Home extends StatelessWidget{
  static Header header = new Header();
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
              },
            )
    ],
      ),
    ));
  }
}