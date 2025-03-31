import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/research/dropdownbutton.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:saemobile/models/typeCuisine.dart';

import '../api/carateristiqueandcuisineapi.dart';

class SettingsScreen extends StatefulWidget {

  final UserViewModel userViewModel;

  const SettingsScreen({super.key, required this.userViewModel});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();

}

class _SettingsScreenState extends State<SettingsScreen> {

  late UserViewModel userViewModel;
  var apiTypes = CaracteristiqueAndCuisineAPI();
  late String selectedType;

  @override
  void initState() {
    super.initState();
    userViewModel = widget.userViewModel;
    _loadUserTypePreference();
  }

  /// recupere le type preferee dans les shared preferences
  void _loadUserTypePreference() async {
    String? type = await userViewModel.getTypePreferee();
    setState(() {
      selectedType = type ?? "non renseigné";
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Votre type favori est : $selectedType",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              FutureBuilder<List<TypeCuisine>>(
                future: apiTypes.getAllTypeCuisine(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      "Erreur : ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return DropdownTypeCuisine(
                      typeCuisines: snapshot.data!,
                      onChanged: (TypeCuisine? value) {
                        if (value != null) {
                          setState(() {
                            selectedType = value.cuisine;
                            userViewModel.setTypePreferee(selectedType);
                          });
                        }
                      },
                    );
                  }
                  return const Text("Aucune cuisine disponible.");
                },
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await userViewModel.setDisconnection();
                },
                child: const Text(
                  'Déconnexion',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}