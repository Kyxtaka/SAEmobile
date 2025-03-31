import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/carateristiqueandcuisineapi.dart';
import 'package:saemobile/models/caracteristique.dart';
import 'package:saemobile/models/typeCuisine.dart';
import 'package:saemobile/UI/research/dropdownbutton.dart';

class SearchScreen extends StatefulWidget {

  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CaracteristiqueAndCuisineAPI caracAndCuisineAPI = CaracteristiqueAndCuisineAPI();

  late Future<void> _loadDataFuture;
  final _formKey = GlobalKey<FormBuilderState>();

  List<TypeCuisine> typeCuisines = [];
  List<Caracteristique> caracteristiques = [];

  TypeCuisine? selectedType;
  Caracteristique? selectedCarac;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    final cuisines = await caracAndCuisineAPI.getAllTypeCuisine();
    final caracs = await caracAndCuisineAPI.getAllCaracterisque();

    setState(() {
      typeCuisines = cuisines;
      caracteristiques = caracs;
      selectedType = cuisines.first;
      selectedCarac = caracs.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
      body: FutureBuilder(
        future: _loadDataFuture, // On utilise le future une seule fois
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          return Center(
            child: Column(
              children: [
                // OutlinedButton(
                //   onPressed: () => {},
                //   child: const Text("En attente de la barre de recherche"),
                // ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.goNamed('decouverte');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Voir tous les restaurants"),
                  ),
                ),

                FormBuilder(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(15.5),
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'search',
                          decoration: const InputDecoration(labelText: 'Rechercher'),
                        )
                      ],
                    ),
                  )
                ),

                // TypeCuisine Dropdown
                DropdownTypeCuisine(
                  typeCuisines: typeCuisines,
                  selectedType: selectedType,
                  onChanged: (TypeCuisine? value) {
                    setState(() {
                      print(value);
                      selectedType = value;
                      print(selectedType?.id);
                    });
                  },
                ),

                // Caracteristique Dropdown
                DropdownCaracteristique(
                  caracteristiques: caracteristiques,
                  selectedCarac: selectedCarac,
                  onChanged: (Caracteristique? value) {
                    setState(() {
                      print(value);
                      selectedCarac = value;
                      print(selectedCarac?.id);
                    });
                  },
                ),

                ElevatedButton(
                  onPressed: () {

                    debugPrint("slected type id string ${selectedType?.id.toString()}");
                    debugPrint("slected  carac id string ${selectedCarac?.id.toString()}");

                    final searchValue = _formKey.currentState?.fields['search']?.value;

                    context.goNamed(
                      'searchResult',
                      queryParameters: {
                        if (selectedType != null) 'cuisine': selectedType?.id.toString(),
                        if (selectedCarac != null) 'carac': selectedCarac?.id.toString(),
                        if (searchValue != null && searchValue.toString().trim().isNotEmpty)
                          'search': searchValue.toString(),
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text(
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
        },
      ),
    );
  }
}
