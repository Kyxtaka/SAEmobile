import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/research/decouverte.dart';
import 'package:saemobile/api/carateristiqueandcuisineapi.dart';
import 'package:saemobile/models/caracteristique.dart';
import 'package:saemobile/models/typeCuisine.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class SearchScreen extends StatefulWidget {
  final SupabaseClient database = Supabase.instance.client;
  @override
  State<StatefulWidget> createState() => _SearchScreenState();

  SearchScreen({super.key});

}

class _SearchScreenState extends State<SearchScreen> {

  late CaracteristiqueAndCuisineAPI caracAndCuisineAPI;
  late Future<List<TypeCuisine>> allTypeCuisine;
  late Future<List<Caracteristique>> allCaracteristique;


  @override
  void initState() {
    super.initState();
    caracAndCuisineAPI = CaracteristiqueAndCuisineAPI(database: this.widget.database);
    allTypeCuisine = caracAndCuisineAPI.getAllTypeCuisine();
    allCaracteristique = caracAndCuisineAPI.getAllCaracterisque();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: Header().create(),
      bottomNavigationBar: Footer().create(context),
      body: FutureBuilder(
          future: allTypeCuisine,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done && !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.data != null) {
              print(allTypeCuisine);
              return FutureBuilder(
                  future: allCaracteristique,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done && !snapshot.hasData) {
                      return Center(child: CircularProgressIndicator(),);
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (snapshot != null) {
                      print(allCaracteristique);
                      return Center(
                        child: const Text("Loaded"),
                      );
                    }

                    return Container();
                  }
                );
            }
            return Container();
          }
      ),
    );
  }

}