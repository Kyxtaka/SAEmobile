
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/api/viewsmodel/critiquesviewmodel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/critique.dart';
import '../global/footer.dart';
import '../global/header.dart';

class Avis extends StatefulWidget {
  @override
  _AvisState createState() => _AvisState();
}

class _AvisState extends State<Avis> {
  // final header = Header();
  late List<Critique> critliste;

  @override
  Widget build(BuildContext context) {
    final critiquesViewModel = context.watch<CritiqueViewModel>();
    print("Avis widget reconstruit !");
    print("Avis page liste: ${critiquesViewModel.liste}");

    if (critiquesViewModel.onLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Avis', style: TextStyle(color: Colors.black))),
        bottomNavigationBar: Footer().create(context),
        body: Center(child: CircularProgressIndicator(),),
      );
    }

    if (critiquesViewModel.liste.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Avis', style: TextStyle(color: Colors.black))),
        bottomNavigationBar: Footer().create(context),
        body: Center(child: Text("Pas d'avis")),
      );
    }
    else {
      print(" avis page liste ${critiquesViewModel.liste}");
      return Scaffold(
        appBar: AppBar(title: Text('Mes Avis', style: TextStyle(color: Colors.black))),
        bottomNavigationBar: Footer().create(context),
        body: ListView.builder(
            itemCount: critiquesViewModel.liste.length,
            itemBuilder: (BuildContext context, int index) {
              var critique = critiquesViewModel.liste[index];
              return critique.renderCard(context, false);
            },
          ),
      );
    }
  }


}

