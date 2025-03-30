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

  void _loadUserTypePreference() async {
    String? type = await userViewModel.getTypePreferee();
    setState(() {
      selectedType = type ?? "";
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: new Footer().create(context),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownTypeCuisine(typeCuisines: [],),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                    backgroundColor: Colors.red
                ),
                onPressed: () async => {
                  await userViewModel.setDisconnection()
                },
                child: const Text(
                  'Déconnexion',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}