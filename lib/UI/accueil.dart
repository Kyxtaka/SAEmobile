import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/SearchBar.dart' hide SearchBar;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/local/tables/typeCuisineTable.dart';
import '../models/typeCuisine.dart';
import 'global/footer.dart';


class Accueil extends StatefulWidget{
  final SupabaseClient database;
  const Accueil({super.key, required this.database});

  @override
  State<Accueil> createState() => _AccueilState();
}
class _AccueilState extends State<Accueil> {
  static Header header = new Header();
  static SearchBar barreRecherche = new SearchBar();
  static TypeCuisineTable cuisineTable = new TypeCuisineTable();

  @override
  Widget build(BuildContext context) {
    Footer footer = new Footer();
    cuisineTable.insertTypeCuisine(1,(new TypeCuisine(1, 'japonais')));
    cuisineTable.insertTypeCuisine(2,new TypeCuisine(2, 'chinois'));
    cuisineTable.insertTypeCuisine(3,new TypeCuisine(4, 'italien'));
    cuisineTable.insertTypeCuisine(4,new TypeCuisine(5, 'allemand'));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: header.create(),
        bottomNavigationBar: footer.create(context),
        body:
        Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              barreRecherche,
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un restaurant...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),

            FutureBuilder<List<TypeCuisine>>(
              future: cuisineTable.getAllTypeCuisines(),
              builder: (context, snapshot) {
                // en attendant les données, petite simulation de chargement
                if ( snapshot.connectionState!=ConnectionState.done && !snapshot.hasData){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // en cas d'erreur
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                // si tout est OK, on affiche les données
                if (snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (BuildContext context, index) {
                        return Card(
                            color: Colors.white,
                            elevation: 7,
                            margin: const EdgeInsets.all(10),
                            child:
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.greenAccent,
                                child: Text(
                                    snapshot.data?[index].id.toString() ??
                                        ""),),
                              title: Text(snapshot.data?[index].cuisine ?? ""),
                            )
                        );
                      }
                  );
                }
                return Container();
              },
            ),
            ],
        )
    )
    );
  }
}
