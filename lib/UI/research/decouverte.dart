import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/boutonDegrade.dart';
import 'package:saemobile/api/restaurantapi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/restaurant.dart';

class Decouverte extends StatefulWidget{
  final SupabaseClient database = Supabase.instance.client;

  Decouverte({super.key});

  @override
  State<Decouverte> createState() => _DecouverteState();
}

class _DecouverteState extends State<Decouverte> {

  late RestaurantAPI restaurantAPI;
  late Future<List<Restaurant>>  futureRestaurants;

  @override
  void initState() {
    super.initState();
    restaurantAPI = RestaurantAPI();
    futureRestaurants = restaurantAPI.getAllRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
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
                          return snapshot.data![index].renderCard(context);
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