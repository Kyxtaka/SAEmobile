import 'package:dropdown_button2/dropdown_button2.dart';
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
  // late Future<List<TypeCuisine>> allTypeCuisine;
  // late Future<List<Caracteristique>> allCaracteristique;


  @override
  void initState() {
    super.initState();
    caracAndCuisineAPI = CaracteristiqueAndCuisineAPI(database: this.widget.database);
    // allTypeCuisine = caracAndCuisineAPI.getAllTypeCuisine();
    // allCaracteristique = caracAndCuisineAPI.getAllCaracterisque();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
      body: FutureBuilder(
          future: caracAndCuisineAPI.getAllTypeCuisine(),
          builder: (context, snapshotCuisine) {
            if (snapshotCuisine.connectionState != ConnectionState.done && !snapshotCuisine.hasData) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (snapshotCuisine.hasError) {
              return Center(
                child: Text(snapshotCuisine.error.toString()),
              );
            }

            if (snapshotCuisine.data != null) {
              return FutureBuilder(
                  future: caracAndCuisineAPI.getAllCaracterisque(),
                  builder: (context, snapshotCarac) {
                    if (snapshotCarac.connectionState != ConnectionState.done && !snapshotCarac.hasData) {
                      return Center(child: CircularProgressIndicator(),);
                    }

                    if (snapshotCarac.hasError) {
                      return Center(
                        child: Text(snapshotCarac.error.toString()),
                      );
                    }

                    if (snapshotCarac != null) {
                      //List<TypeCuisine> allTypeCuisine = (List<TypeCuisine>) allTypeCuisine,
                      TypeCuisine? selectedType;
                      Caracteristique? selectedCarac;

                      return Center(
                        child: Column(
                          children: [
                            OutlinedButton(
                                onPressed: () => {},
                                child: Text("En attente de la barre de recherche")
                            ),
                            DropdownButtonHideUnderline(
                                child: DropdownButton2<TypeCuisine>(
                                    isExpanded: true,
                                    hint: const Row(
                                      children: [
                                        Icon(
                                          Icons.list,
                                          size: 16,
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
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
                                    items: snapshotCuisine.data!
                                        .map<DropdownMenuItem<TypeCuisine>>((TypeCuisine item) => DropdownMenuItem<TypeCuisine>(
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
                                    )).toList(),

                                  value: selectedType,
                                  onChanged: (TypeCuisine? valueType) {
                                      debugPrint("value changed");
                                    setState(() {
                                      selectedType = valueType;
                                      debugPrint("selected input: ${valueType.toString()} / id ${valueType?.id} type ${valueType?.id.runtimeType} / cuisine ${valueType?.cuisine} type ${valueType?.cuisine.runtimeType}");
                                    });
                                    debugPrint("current cuisine value ${selectedType?.cuisine}");
                                  },
                                )
                            ),
                            DropdownButtonHideUnderline(
                                child: DropdownButton2<Caracteristique>(
                                  isExpanded: true,
                                  hint: selectedCarac == null ? Row(
                                    children: [
                                      Icon(
                                        Icons.list,
                                        size: 16,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Séléctionnez une caractéristique',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ) : Text(
                                    selectedCarac.carac,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  items: snapshotCarac.data!
                                      .map<DropdownMenuItem<Caracteristique>>((Caracteristique item) => DropdownMenuItem<Caracteristique>(
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
                                  )).toList(),

                                  value: selectedCarac,
                                  onChanged: (Caracteristique? valueCarac) {
                                    debugPrint("value changed");
                                    setState(()  {
                                      selectedCarac = valueCarac;
                                      debugPrint("selected input: ${valueCarac.toString()} / id ${valueCarac?.id} type ${valueCarac?.id.runtimeType} / cuisine ${valueCarac?.carac} type ${valueCarac?.carac.runtimeType}");
                                    });
                                    debugPrint("current carac value ${selectedCarac?.carac}");
                                  },
                                )
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 🔥 Ajuste l'espace intérieur
                              ),
                              child: Text(
                                  "Rechercher",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ) ,
                                  overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
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