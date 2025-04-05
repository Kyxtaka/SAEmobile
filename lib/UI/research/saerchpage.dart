import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/carateristiqueandcuisineapi.dart';
import 'package:saemobile/api/restaurantapi.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:saemobile/models/caracteristique.dart';
import 'package:saemobile/models/typeCuisine.dart';
import 'package:saemobile/UI/research/dropdownbutton.dart';

class SearchScreen extends StatefulWidget {

  final bool shouldFocus;
  final String? initialCuisineId;
  final bool autoSearch;

  const SearchScreen({
    super.key,
    this.shouldFocus = false,
    this.initialCuisineId,
    this.autoSearch = false,
  });

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  final CaracteristiqueAndCuisineAPI caracAndCuisineAPI = CaracteristiqueAndCuisineAPI();

  late Future<void> _loadDataFuture;
  final _formKey = GlobalKey<FormBuilderState>();

  List<TypeCuisine> typeCuisines = [];
  List<Caracteristique> caracteristiques = [];
  late var position;
  late var restauranstByPosition;

  TypeCuisine? selectedType;
  Caracteristique? selectedCarac;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
    if (widget.shouldFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final cuisines = await caracAndCuisineAPI.getAllTypeCuisine();
    final caracs = await caracAndCuisineAPI.getAllCaracterisque();
    position = await UserViewModel.getLocalisation();
    restauranstByPosition = await RestaurantAPI.getRestaurantsByLocation(position.latitude, position.longitude);

    setState(() {
      typeCuisines = cuisines;
      caracteristiques = caracs;
      selectedType = cuisines.first;
      selectedCarac = caracs.first;
      if (widget.initialCuisineId != null) {
        final matchedType = cuisines.firstWhere(
              (c) => c.id.toString() == widget.initialCuisineId,
        );
        selectedType = matchedType;
      }
    });

  if (widget.autoSearch && widget.initialCuisineId != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.goNamed(
        'searchResult',
        queryParameters: {
          'cuisine': widget.initialCuisineId!,
          'carac': '-1',
        },
      );
    });
    }
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

          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Supprime le border radius
                        ),
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
                          focusNode: _focusNode,
                          controller: _controller,
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
                        // print(value);
                        selectedType = value;
                        // print(selectedType?.id);
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

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: ElevatedButton(
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
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: FlutterMap(
                        options: MapOptions(
                            initialCenter : position,
                            initialZoom:13
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: position, // center of 't Gooi
                                radius: 150,
                                useRadiusInMeter: true,
                                color: Colors.red,
                                borderColor: Colors.red,
                                borderStrokeWidth: 2,
                              )
                            ],
                          ),
                          setRestaurantsByPosition(context)]),)
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget setRestaurantsByPosition(BuildContext context) {
    List<Marker> markersRestaurants = [];

    for (var i = 0; i < restauranstByPosition.length; i++) {
      markersRestaurants.add(
        Marker(
          point: LatLng(
              restauranstByPosition[i]['lat'],
              restauranstByPosition[i]['long']
          ),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              context.go('/details/${restauranstByPosition[i]['id']}');
            },
            child: Icon(
              Icons.location_on,
              color: Colors.orange,
              size: 40,
            ),
          ),
        ),
      );
    }
    return MarkerLayer(
      markers: markersRestaurants,
    );
  }
}
