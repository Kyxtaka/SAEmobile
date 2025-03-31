
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/api/viewsmodel/critiquesviewmodel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../global/footer.dart';
import '../global/header.dart';

class Avis extends StatefulWidget {
  @override
  _AvisState createState() => _AvisState();
}

class _AvisState extends State<Avis> {
  // final header = Header();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final critiquesViewModel = context.watch<CritiqueViewModel>();
    print("Avis widget reconstruit !");
    print("Avis page liste: ${critiquesViewModel.liste}");

    if (critiquesViewModel.liste.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Avis', style: TextStyle(color: Colors.black))),
        bottomNavigationBar: Footer().create(context),
        body: Text("Pas d'avis"),
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
            return Card(
              child: ListTile(
                title: Text(
                  'Vous avez critiqué ${critique.restaurant!.name} le ${critique.date_test}',
                ),

                /// cette partie a été généré à l'aide d'une IA générative
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBarIndicator(
                      rating: critique.note.toDouble(),
                      itemBuilder: (context, index) =>
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                      itemCount: 5,
                      itemSize: 24.0,
                      direction: Axis.horizontal,
                    ),
                    SizedBox(height: 8),
                    Text(critique.message),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          iconSize: 20,
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            bool isDeleted = await Provider.of<CritiqueViewModel>(context, listen: false).deleteCritique(critique);
                            if (!isDeleted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Erreur : impossible de supprimer la review"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                            iconSize: 20,
                            color: Colors.grey,
                            icon: const Icon(Icons.edit),
                            onPressed: () => context.go('/avis/${critique.id}'),
                        ),
                        IconButton(
                            iconSize: 20,
                            color: Colors.grey,
                            onPressed: () {
                              context.go('/details/${critique.restaurant?.id}');
                            },
                            icon: Icon(Icons.restaurant))
                      ]
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }


}

