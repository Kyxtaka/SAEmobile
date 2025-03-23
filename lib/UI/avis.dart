
import 'package:flutter/material.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/models/critique.dart';
import 'package:saemobile/utils/UserTools.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/local/sqlfliteDatabase.dart';

class Avis extends StatefulWidget {
  @override
  _AvisState createState() => _AvisState();
}

class _AvisState extends State<Avis> {
  CritiqueAPI critiqueAPI = new CritiqueAPI(database: Supabase.instance.client);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


  }


}