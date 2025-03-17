import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/header.dart';
class Accueil extends StatelessWidget{
  static Header header = new Header();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header.create(),
        body: Center(

        )
    );
  }
}