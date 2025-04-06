import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/restaurantapi.dart';
import 'package:saemobile/models/restaurant.dart';

class SearchResult extends StatefulWidget {
  final int cuisine;
  final int carac;
  final String search;

  const SearchResult({super.key, required this.cuisine, required this.carac, required this.search});

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final  RestaurantAPI  restAPI = RestaurantAPI();

  late Future<void> _loadDataRestaurant;

  List<Restaurant> restaurantsList = [];

  @override
  void initState() {
    super.initState();
    _loadDataRestaurant = _loadData();

  }

  Future<void> _loadData() async {
    List<Restaurant>? restaurants;
    if (widget.carac != -1 && widget.cuisine != -1) {
      restaurants = await restAPI.getRestaurantByCaracAndCuisine(widget.carac, widget.cuisine);

    }else if (widget.carac != -1 && widget.cuisine == -1) {
      restaurants = await restAPI.getRestaurantByCarac(widget.carac);

    }else if (widget.carac == -1 && widget.cuisine != -1) {
      restaurants = await restAPI.getRestaurantByCuisine(widget.cuisine);

    }else {
      restaurants = await restAPI.getAllRestaurants();
    }

    print('=========================================> seach = ${widget.search}');
    print(widget.search.runtimeType);

    if (widget.search.toLowerCase() != "null") {
      restaurants?.removeWhere((rest) => !rest.name.toLowerCase().contains(widget.search.toLowerCase()));
      // restaurants = restaurants.where((rest) => rest.name.contains(widget.search)).toList();
    }

    setState(() {
      restaurantsList = restaurants!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
      // body: Center(
      //   child: Text("Loded with cuisine: ${widget.cuisine} and carac: ${widget.carac}"),
      // ),
      body: FutureBuilder(
          future: _loadDataRestaurant,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()),);
            }
            
            if (restaurantsList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Aucun restaurants ne correspond à votre recherche")
                  ],
                ),
              );
            }

            return Center(
              child: ListView.builder(
                itemCount: restaurantsList.length,
                  itemBuilder: (context, index) {
                    return restaurantsList[index].renderCard(context);
                  },
                ),
            );
          }
      ),
    );
  }

}