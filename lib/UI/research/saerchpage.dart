import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/carateristiqueandcuisineapi.dart';
import 'package:saemobile/models/caracteristique.dart';
import 'package:saemobile/models/typeCuisine.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:saemobile/UI/research/dropdownbutton.dart';

class SearchScreen extends StatefulWidget {
  final SupabaseClient database = Supabase.instance.client;
  TypeCuisine? selectedType;
  Caracteristique? selectedCarac ;


  @override
  State<StatefulWidget> createState() => _SearchScreenState();

  SearchScreen({super.key});

}

class _SearchScreenState extends State<SearchScreen> {
  final CaracteristiqueAndCuisineAPI caracAndCuisineAPI = CaracteristiqueAndCuisineAPI();
  late Future<List<TypeCuisine>> allTypeCuisine;
  late Future<List<Caracteristique>> allCaracteristique;

  @override
  void initState() {
    super.initState();
    allTypeCuisine = caracAndCuisineAPI.getAllTypeCuisine();
    allCaracteristique = caracAndCuisineAPI.getAllCaracterisque();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
      body: FutureBuilder(
        future: Future.wait([allTypeCuisine, allCaracteristique]),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }


          if (snapshot.hasData) {
            List<TypeCuisine> typeCuisines = snapshot.data![0] as List<TypeCuisine>;
            List<Caracteristique> caracteristiques = snapshot.data![1] as List<Caracteristique>;



            return Center(
              child: Column(
                children: [
                  OutlinedButton(
                      onPressed: () => {},
                      child: Text("En attente de la barre de recherche")),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.goNamed('decouverte');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text("Voir tous les restaurants"),
                    ),
                  ),

                  // TypeCuisine Dropdown
                  DropdownTypeCuisine(
                    typeCuisines: typeCuisines,
                    selectedType: widget.selectedType,
                    onChanged: (value) {
                      setState(() {
                        widget.selectedType = value!;
                      });

                    },
                  ),

                  // Caracteristique Dropdown
                  DropdownCaracteristique(
                    caracteristiques: caracteristiques,
                    selectedCarac: widget.selectedCarac,
                    onChanged: (value) {
                      setState(() {
                        widget.selectedCarac = value!;
                      });
                    },
                  ),

                  ElevatedButton(
                    onPressed: () {
                      context.goNamed(
                        'searchResult',
                        queryParameters: {
                          'cuisine': widget.selectedCarac?.getGlobalId().toString(),
                          'caracteristique': widget.selectedCarac?.getGlobalId().toString(),
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      "Rechercher",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}


