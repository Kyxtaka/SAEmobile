import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  TypeCuisine? selectedType;
  Caracteristique? selectedCarac;

  late Future<List<TypeCuisine>> allTypeCuisine;
  late Future<List<Caracteristique>> allCaracteristique;

  @override
  void initState() {
    super.initState();
    caracAndCuisineAPI = CaracteristiqueAndCuisineAPI();
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
                    selectedType: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),

                  // Caracteristique Dropdown
                  DropdownCaracteristique(
                    caracteristiques: caracteristiques,
                    selectedCarac: selectedCarac,
                    onChanged: (value) {
                      setState(() {
                        selectedCarac = value;
                      });
                    },
                  ),

                  ElevatedButton(
                    onPressed: () {},
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

class DropdownTypeCuisine extends StatefulWidget {
  final List<TypeCuisine> typeCuisines;
  final ValueChanged<TypeCuisine?> onChanged;
  final TypeCuisine? selectedType;

  const DropdownTypeCuisine({
    required this.typeCuisines,
    required this.onChanged,
    this.selectedType,
    super.key,
  });

  @override
  _DropdownTypeCuisineState createState() => _DropdownTypeCuisineState();
}

class _DropdownTypeCuisineState extends State<DropdownTypeCuisine> {
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<TypeCuisine>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.deepOrangeAccent,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                'Sélectionnez un type de cuisine',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: widget.typeCuisines.map<DropdownMenuItem<TypeCuisine>>(
              (TypeCuisine item) {
            return DropdownMenuItem<TypeCuisine>(
              value: item,
              child: Text(
                item.cuisine,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ).toList(),
        value: widget.selectedType,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class DropdownCaracteristique extends StatefulWidget {
  final List<Caracteristique> caracteristiques;
  final ValueChanged<Caracteristique?> onChanged;
  final Caracteristique? selectedCarac;

  const DropdownCaracteristique({
    required this.caracteristiques,
    required this.onChanged,
    this.selectedCarac,
    super.key,
  });

  @override
  _DropdownCaracteristiqueState createState() => _DropdownCaracteristiqueState();
}

class _DropdownCaracteristiqueState extends State<DropdownCaracteristique> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<Caracteristique>(
        isExpanded: true,
        hint: widget.selectedCarac == null
            ? const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.deepOrangeAccent,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                'Sélectionnez une caractéristique',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )
            : Text(
          widget.selectedCarac!.carac,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        items: widget.caracteristiques.map<DropdownMenuItem<Caracteristique>>(
              (Caracteristique item) {
            return DropdownMenuItem<Caracteristique>(
              value: item,
              child: Text(
                item.carac,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ).toList(),
        value: widget.selectedCarac,
        onChanged: widget.onChanged,
      ),
    );
  }
}