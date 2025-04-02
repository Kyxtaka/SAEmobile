

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    final favorisViewModel = context.watch<FavorisViewModel>();
    if (favorisViewModel.favoris.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Favoris sur mon appareil')),
        bottomNavigationBar: Footer().create(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Pas de favoris actuellement"),
              Text("Pourquoi pas en ajouter ?"),
              ElevatedButton(
                  onPressed: () {
                    context.goNamed('decouverte');
                  },
                  child: Text("Découvrir des restaurants")
              )
            ],
          ),
        ),
      );
    }
    else {
    return Scaffold(
      appBar: AppBar(title: Text("Mes Favoris", style: TextStyle(color:Colors.black))),
      bottomNavigationBar: Footer().create(context),
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
                    fav.address,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(fav.name ?? "Restaurant"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          iconSize: 20,
                          color: Colors.grey,
                          onPressed: () {
                            context.go('/details/${fav.id}');
                          },
                          icon: Icon(Icons.restaurant)),
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () async {
                          var user = await UserViewModel.getCurrentUser();
                          favorisViewModel.removeFavoris(user, fav.id);
                          if (context.mounted) {
                            context.go('/favoris');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ));
        }
  }
}
