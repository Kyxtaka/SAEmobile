

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/api/viewsmodel/favorisviewmodel.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';

import 'global/footer.dart';

class Favoris extends StatefulWidget {


  @override
  State<Favoris> createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {

  Widget build(BuildContext context) {
    var footer = Footer();
    final favorisViewModel = context.watch<FavorisViewModel>();
    if (favorisViewModel.favoris.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Favoris')),
        bottomNavigationBar: footer.create(context),
        body: Text("Pas de favoris"),
      );
    }
    else {
    return Scaffold(
      appBar: AppBar(title: Text("Mes Favoris")),
      bottomNavigationBar: footer.create(context),
      body: ListView.builder(
            itemCount: favorisViewModel.favoris.length,
            itemBuilder: (context, index) {
              var fav = favorisViewModel.favoris[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Text(
                    fav.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(fav.name ?? "Restaurant"),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => favorisViewModel.removeFavoris(UserViewModel.getCurrentUser(), fav.id),
                  ),
                ),
              );
            },
          ));
        }
  }
}
