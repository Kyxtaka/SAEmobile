import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  String selectedType = "non renseigné";
  String localisation = "non renseignée";
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();
    userViewModel = widget.userViewModel;
    _loadUserTypePreference();
  }

  /// recupere le type preferee dans les shared preferences
  void _loadUserTypePreference() async {
    String? type = await userViewModel.getTypePreferee();
    String pos = await userViewModel.getLocalisation();
    setState(() {
      selectedType = type ?? "non renseigné";
      localisation = pos;
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
              Text("Votre position actuelle est "),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8, // 80% de la hauteur de l'écran
                child:GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var position = await _determinePosition();
                    userViewModel.setLocalisation(position.toString());
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

