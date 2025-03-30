

import 'package:flutter/material.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/critique.dart';
import '../global/footer.dart';
import '../global/header.dart';

class CritiqueRestaurants extends StatelessWidget{
  final String restaurantId;
  CritiqueRestaurants({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    var footer = Footer();
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: footer.create(context),
        appBar: Header.create(),
        body: FutureBuilder<List<Critique>>(
          future: CritiqueAPI.getCritiquesForRestaurant(restaurantId),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              return  ListView.builder(
              itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  final critique = snapshot.data?[index];
                  if (critique == null) {
                    return Text("Erreur dans la récupération d'une review");
                  }
                  return Card(
                      child: ListTile(
                          title: Text(
                            '${critique.user?.prenom} ${critique.user?.nom} avez critiqué le ${critique
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
                                Text(critique.message)
                              ])
                      )
                  );
                });
            }
            return Text("Pas de review");
          }
        )
    );
  }

}