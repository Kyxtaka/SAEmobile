import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/research/decouverte.dart';
import 'package:saemobile/api/restaurantAPI.dart';
import 'package:saemobile/models/restaurant.dart';

class InjectedDecouverte extends Decouverte {
  final RestaurantAPI api;

  InjectedDecouverte({required this.api});

  @override
  State<Decouverte> createState() => _TestableDecouverteState();
}

class _TestableDecouverteState extends State<Decouverte> {
  late Future<List<Restaurant>> futureRestaurants;

  @override
  void initState() {
    super.initState();
    final widgetWithApi = widget as InjectedDecouverte;
    futureRestaurants = widgetWithApi.api.getAllRestaurants();
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
