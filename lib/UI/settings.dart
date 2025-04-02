import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/research/dropdownbutton.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:saemobile/models/typeCuisine.dart';
import 'package:saemobile/models/user.dart';
import 'package:saemobile/services/local/tables/cuisinePrefereesTable.dart';
import 'package:saemobile/api/viewsmodel/critiquesviewmodel.dart';
import 'package:saemobile/api/viewsmodel/favorisviewmodel.dart';
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
  String selectedType = "non renseigné";
  LatLng localisation = LatLng(47.916672, 1.9);

  @override
  void initState() {
    super.initState();
    userViewModel = widget.userViewModel;
    _loadUserTypePreference();
  }

  /// recupere le type preferee dans les shared preferences
  void _loadUserTypePreference() async {
    var user = await UserViewModel.getCurrentUser();
    String? type = await CuisinesPrefereesTable.getCuisinesPreferees(user);
    LatLng pos = await UserViewModel.getLocalisation();
    setState(() {
      selectedType = type ?? "non renseigné";
      localisation = pos;
    });
  }


  @override
  Widget build(BuildContext context) {
    final critiquesViewModel = Provider.of<CritiqueViewModel>(context, listen: false);
    final favorisViewModel = Provider.of<FavorisViewModel>(context, listen: false);

    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
      body: SafeArea(
          child: Column(
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
                          setState(() async {
                            selectedType = value.cuisine;
                            var user = await UserViewModel.getCurrentUser();
                            CuisinesPrefereesTable.insertCuisinePrefere(user, value.id, value.cuisine);
                          });
                        }
                      },
                    );
                  }
                  return const Text("Aucune cuisine disponible.");
                },
              ),

              const SizedBox(height: 40),
              Text("Votre position actuelle est "),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter : localisation,
                          initialZoom:11
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: localisation, // center of 't Gooi
                                radius: 200,
                                useRadiusInMeter: true,
                                color: Colors.red,
                                borderColor: Colors.red,
                                borderStrokeWidth: 2,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var position = await _determinePosition();
                    userViewModel.setLocalisation(position);
                  },
                  child: Text("Récupérer votre localisation")),
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
                  await critiquesViewModel.generateCritiques("");
                  await favorisViewModel.generateFavoris("");
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

    );

  }

  /// recuperé depuis la documentation officielle
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}

