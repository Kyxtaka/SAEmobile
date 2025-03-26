
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/api/viewsmodel/critiquesviewmodel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'global/footer.dart';
import 'global/header.dart';

class Avis extends StatefulWidget {
  @override
  _AvisState createState() => _AvisState();
}

class _AvisState extends State<Avis> {
  final header = new Header();

  @override
  Widget build(BuildContext context) {
    Footer footer = Footer();
    final critiquesViewModel = context.watch<CritiqueViewModel>();
    if (critiquesViewModel.liste.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Mes Avis')),
        bottomNavigationBar: footer.create(context),
        body: Text("Pas d'avis"),
      );
    }
    else {
      return Scaffold(
        appBar: header,
        bottomNavigationBar: footer.create(context),
        body: ListView.builder(
          itemCount: critiquesViewModel.liste.length,
          itemBuilder: (BuildContext context, int index) {
            final critique = critiquesViewModel.liste[index];
            return Card(
              child: ListTile(
                title: Text(
                  'Vous avez critiqué ${critique.restaurant!.name} le ${critique
                      .date_test}',
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
                                  content: Text("Erreur : impossible de supprimer la critique"),
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

