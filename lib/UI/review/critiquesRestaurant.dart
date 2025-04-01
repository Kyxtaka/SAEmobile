

import 'package:flutter/material.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/critique.dart';
import '../global/footer.dart';
import '../global/header.dart';

class CritiqueRestaurants extends StatelessWidget{
  final String restaurantId;
  CritiqueRestaurants({required this.restaurantId});

  Future<void> _initWidgetImg(List<Critique> critiques) async{
    for(Critique crit in critiques) {
      await crit.getCritiqueImageIfExist();
    }
  }

  @override
  Widget build(BuildContext context) {
    var footer = Footer();
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: footer.create(context),
        appBar: Header.create(),
        body: FutureBuilder<List<Critique>>(
          future: CritiqueAPI.getCritiquesForRestaurant(restaurantId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              for (var i = 0 ; i < snapshot.data!.length; i++) {
                snapshot.data![i].getCritiqueImageIfExist();
              }
              return  FutureBuilder(
                  future: _initWidgetImg(snapshot.data!),
                  builder: (context, snapshot2) {
                    if (snapshot2.connectionState != ConnectionState.done) {
                      return Center(child: const CircularProgressIndicator(),);
                    }

                    if (snapshot2.hasError) {
                      return Center(
                        child: Text(snapshot2.error.toString()),
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          final critique = snapshot.data?[index];
                          if (critique == null) {
                            return Text("Erreur dans la récupération d'une review");
                          }
                          return critique.renderCard(context);
                        }
                    );
                  }
              );
            }
            return Text("Pas de review");
          }
        )
    );
  }

}