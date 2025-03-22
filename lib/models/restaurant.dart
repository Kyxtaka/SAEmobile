class Restaurant {
  final int _id;
  final String _name;
  final String _address;
  final int _capacity;
  final String _tel;
  final String _siret;
  final String _website;
  final String _url_photo;
  final int _id_cuisine;
  final int _id_region;
  final int _nb_etoile;
  final String _horaires;
  final double _gps_lat;
  final double _gps_long;

  const Restaurant(
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

  String get horraire => _horaires;

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

}