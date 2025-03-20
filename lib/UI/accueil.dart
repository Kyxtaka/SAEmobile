import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/SearchBar.dart';

class Accueil extends StatelessWidget{
  static Header header = new Header();
  static SearchBarApp barreRecherche = new SearchBarApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: header.create(),
        body:
        Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              barreRecherche,
            ],
        )
    )
    );
  }
}