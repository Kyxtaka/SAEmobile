class Restaurant {
  int _id;
  String _name;
  String _address;
  int _capacity;
  String _tel;
  String _siret;
  String _website;
  String _url_photo;
  int _id_cuisine;
  int _id_region;
  int _nb_etoile;
  String _horaires;
  double _gps_lat;
  double _gps_long;

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

  set gps_long(double value) {
    _gps_long = value;
  }

  double get gps_lat => _gps_lat;

  set gps_lat(double value) {
    _gps_lat = value;
  }

  String get horraire => _horaires;

  set horraire(String value) {
    _horaires = value;
  }

  int get id_region => _id_region;

  set id_region(int value) {
    _id_region = value;
  }

  int get id_cuisine => _id_cuisine;

  set id_cuisine(int value) {
    _id_cuisine = value;
  }

  String get url_photo => _url_photo;

  set url_photo(String value) {
    _url_photo = value;
  }

  String get website => _website;

  set website(String value) {
    _website = value;
  }

  String get siret => _siret;

  set siret(String value) {
    _siret = value;
  }

  String get tel => _tel;

  set tel(String value) {
    _tel = value;
  }

  int get capacity => _capacity;

  set capacity(int value) {
    _capacity = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get nb_etoile => _nb_etoile;

  set nb_etoile(int value) {
    _nb_etoile = value;
  }

  void debugPrint() {
    String restaurant = "id: $_id, name: $_name, address: $_address, capacity: $_capacity, tel: $_tel, siret: $_siret, website: $_website, url_photo: $_url_photo, id_cuisine: $_id_cuisine, id_region: $_id_region, horraire: $_horaires, gps_lat: $_gps_lat, gps_long: $gps_long";
    print(restaurant);
  }

}