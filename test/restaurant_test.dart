import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:saemobile/models/restaurant.dart';

void main() {
  test("Teste les getters de l'objet Critique", (){
    var restaurant = new Restaurant(1, "Au Bouillon", "3 rue perdu", 100, "+33 2 34 45 56 67", "123456789", "aubouillon.com", "", 1, 45, 0, "12h-14h/18h-22h Lun à Sam", 0.0, 0.0);
    expect(restaurant.id, 1);
    expect(restaurant.name, "Au Bouillon");
    expect(restaurant.address, "3 rue perdu");
    expect(restaurant.capacity, 100);
    expect(restaurant.gps_lat, 0.0);
    expect(restaurant.gps_long, 0.0);
    expect(restaurant.horaire, '12h-14h/18h-22h Lun à Sam');
    expect(restaurant.id_cuisine, 1);
    expect(restaurant.nb_etoile, 0);
    expect(restaurant.siret, "123456789");
    expect(restaurant.tel, "+33 2 34 45 56 67");
    expect(restaurant.website, "aubouillon.com");
    expect(restaurant.id_region, 45);
    expect(restaurant.url_photo, "");
    expect(restaurant.toMapLocal(), {'id': 1,
      'name': "Au Bouillon",
      'address': "3 rue perdu"});
  });
}