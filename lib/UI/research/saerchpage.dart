import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/carateristiqueandcuisineapi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class SearchScreen extends StatefulWidget {
  final SupabaseClient database = Supabase.instance.client;
  @override
  State<StatefulWidget> createState() => _SearchScreenState();

  SearchScreen({super.key});

}

class _SearchScreenState extends State<SearchScreen> {

  late CaracteristiqueAndCuisineAPI caracAndCuisineAPI;

  @override
  void initState() {
    super.initState();
    caracAndCuisineAPI = CaracteristiqueAndCuisineAPI(database: this.widget.database);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
    );
  }

}