import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperlink/hyperlink.dart';
import 'package:url_launcher/url_launcher.dart';
class Restaurant {
  final int _id;
  final String _name;
  late  String _address;
  final int _capacity;
  final String _tel;
  final String _siret;
  late  String _website;
  late  String _url_photo;
  final int _id_cuisine;
  final int _id_region;
  final int _nb_etoile;
  final String _horaires;
  final double _gps_lat;
  final double _gps_long;

   Restaurant(
      this._id,
      this._name,
      this._address,
      this._capacity,
      this._tel,
      this._siret,
      this._website,
      this._url_photo,
      this._id_cuisine,
      this._id_region,
      this._nb_etoile,
      this._horaires,
      this._gps_lat,
      this._gps_long);

  double get gps_long => _gps_long;

  double get gps_lat => _gps_lat;

  String get horaire => _horaires;

  int get id_region => _id_region;

  int get id_cuisine => _id_cuisine;

  String get url_photo => _url_photo;

  String get website => _website;

  String get siret => _siret;

  String get tel => _tel;

  int get capacity => _capacity;

  String get address => _address;

  String get name => _name;

  int get id => _id;

  int get nb_etoile => _nb_etoile;


  set address(String value) {
    _address = value;
  }

  set website(String value) {
    _website = value;
  }

  set url_photo(String value) {
    _url_photo = value;
  }

  void debugPrint() {
    String restaurant = "id: $_id, name: $_name, address: $_address, capacity: $_capacity, tel: $_tel, siret: $_siret, website: $_website, url_photo: $_url_photo, id_cuisine: $_id_cuisine, id_region: $_id_region, horraire: $_horaires, gps_lat: $_gps_lat, gps_long: $gps_long";
    print(restaurant);
  }

  Map<String, Object?> toMapLocal() {
    return {
      'id': _id,
      'name': _name,
      'address': _address
    };
  }

  Widget renderCard(BuildContext context) {
    
    bool ableRedirecting = false;
    if (website != "None") {
      ableRedirecting = true;
    }else {
      website = "Pas de site web";
    }

    GestureDetector redirect = GestureDetector(
      onTap: () async {
        if (ableRedirecting) {
          final Uri url = Uri.parse(website);
          if ( await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Impossible d'ouvrir le lien")),
            );
          }
        }
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: 20),
        child: Text(
          website ?? "pas de site web",
          style: TextStyle(
            fontSize: 12,
            color: ableRedirecting ? Colors.blue : Colors.grey,
            decoration: ableRedirecting ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10),
      child: ListTile(
          leading: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  url_photo,
                  width: 300,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                    Image.asset(
                      'assets/img/default-image.png',
                      width: 150,
                      height: 350,
                    ),
                ),
              ),
              // hyperLink(context),
            ],
          ),
          title: Text(name ?? ""),
          subtitle: redirect,
          onTap: () {
            context.go('/details/$id');
          }
      ),
    );
  }
}