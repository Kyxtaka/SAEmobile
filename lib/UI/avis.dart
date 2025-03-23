
import 'package:flutter/material.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/models/critique.dart';
import 'package:saemobile/utils/UserTools.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/local/sqlfliteDatabase.dart';
import 'global/footer.dart';
import 'global/header.dart';

class Avis extends StatefulWidget {
  @override
  _AvisState createState() => _AvisState();
}

class _AvisState extends State<Avis> {
  CritiqueAPI critiqueAPI = new CritiqueAPI(database: Supabase.instance.client);
  final header = new Header();
  late final critiques;

  void getCritiques(){
    critiques = critiqueAPI.getCritiqueForUser("mail@mail");
  }

  @override
  Widget build(BuildContext context) {
    Footer footer = new Footer();
    getCritiques();
    return Scaffold(
      appBar : header,
      bottomNavigationBar: footer.create(),
      body: ListView.builder(
        itemCount: critiques.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: ListTile(
                title : critiques[index].user.nom + critiques[index].user.prenom,
                subtitle: critiques[index].message,
              )
          );
        },)
    );
  }


}

