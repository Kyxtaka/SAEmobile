
import 'package:flutter/material.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/models/critique.dart';
import 'package:saemobile/utils/UserTools.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'global/footer.dart';
import 'global/header.dart';

class Avis extends StatefulWidget {
  @override
  _AvisState createState() => _AvisState();
}

class _AvisState extends State<Avis> {
  CritiqueAPI critiqueAPI = new CritiqueAPI(database: Supabase.instance.client);
  final header = new Header();
  late Future<List<Critique>> critiquesFuture;

  @override
  void initState() {
    super.initState();
    critiquesFuture = critiqueAPI.getCritiqueForUser("mail@mail");
  }

  @override
  Widget build(BuildContext context) {
    Footer footer = Footer();

    return Scaffold(
      appBar: header,
      bottomNavigationBar: footer.create(context),
      body: FutureBuilder<List<Critique>>(
        future: critiquesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Vous n'avez pas encore critiqué des restaurants"));
          }

          List<Critique> critiques = snapshot.data!;

          return ListView.builder(
            itemCount: critiques.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(
                    'Vous avez critiqué ${critiques[index].restaurant!.name} le ${critiques[index].date_test}',
                  ),
                  /// cette partie a été généré à l'aide d'une IA générative
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBarIndicator(
                        rating: critiques[index].note.toDouble(),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 24.0,
                        direction: Axis.horizontal,
                      ),
                      SizedBox(height: 8),
                      Text(critiques[index].message),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }


}

