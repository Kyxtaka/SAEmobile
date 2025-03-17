
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/boutonDegrade.dart';
import 'themes/theme.dart';

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
            Padding(
              padding: EdgeInsets.all(50.0),
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8.0),
                child: Text("Les restaurants d'Orléans dans votre poche !" ),
              ),
            ),
            BoutonDegrade(
              text: "Se connecter",
              onPressed: () => context.go('/login'),
            ),
            Padding(
              padding: EdgeInsets.only(top:5.0),
              child: Text("Pas de compte ?", style: MyTheme.loginStyle() ),
            ),
            TextButton(child: Text("Inscrivez-vous !", style: TextStyle(color: Colors.deepOrange,decoration: TextDecoration.underline,)), onPressed: ()=>context.go('/subscribe'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Enlève le padding par défaut
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Réduit la taille du bouton au texte
                    ),)

    ],
      ),
    ));
  }
}