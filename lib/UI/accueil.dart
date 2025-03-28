import 'package:flutter/material.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/UI/themes/SearchBar.dart' hide SearchBar;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'global/footer.dart';


class Accueil extends StatefulWidget{
  final SupabaseClient database;
  const Accueil({super.key, required this.database});

  @override
  State<Accueil> createState() => _AccueilState();
}
class _AccueilState extends State<Accueil> {
  static SearchBar barreRecherche = new SearchBar();

  @override
  Widget build(BuildContext context) {
    Footer footer = new Footer();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: Header.create(),
        bottomNavigationBar: footer.create(context),
        body:
        Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              barreRecherche,
            ],
        )
    )
    );
  }
}
