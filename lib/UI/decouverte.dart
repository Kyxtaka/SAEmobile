import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/boutonDegrade.dart';
import 'package:saemobile/api/restaurantapi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/restaurant.dart';

class Decouverte extends StatefulWidget{
  final Header header = new Header();
  final SupabaseClient database;

  Decouverte({super.key, required this.database});

  @override
  State<Decouverte> createState() => _DecouverteState();
}

class _DecouverteState extends State<Decouverte> {

  late RestaurantAPI restaurantAPI;
  late Future<List<Restaurant>>  futureRestaurants;

  @override
  void initState() {
    super.initState();
    restaurantAPI = RestaurantAPI(database: widget.database);
    futureRestaurants = restaurantAPI.getAllRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.header.create(),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: futureRestaurants,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done &&
                        !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (snapshot.data != null) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 6,
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Colors.amber,
                                    child: Text(snapshot.data?[index].id.toString() ?? "")
                                ),
                                title: Text(snapshot.data?[index].name ?? ""),
                                subtitle: Text(snapshot.data?[index].address ?? ""),
                              )
                          );
                        },
                      );
                    }
                    return Container();
                  }
              ),
          ),
        ],
      )
    );
  }
}