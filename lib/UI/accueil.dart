import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/searchBar.dart';

class Accueil extends StatelessWidget{
  static Header header = new Header();
  static searchBar barreRecherche = new searchBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header.create(),
        body: Center(
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              barreRecherche,
            ],
        )
    )
    );
  }
}