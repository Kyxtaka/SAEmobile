
import 'package:flutter_test/flutter_test.dart';
import 'package:saemobile/models/critique.dart';
import 'package:saemobile/models/restaurant.dart';
import 'package:saemobile/models/user.dart';

void main() {
  test("Teste les getters de l'objet Critique", (){
    var restaurant = Restaurant(1, "Au Bouillon", "3 rue perdu", 100, "+33 2 34 45 56 67", "123456789", "aubouillon.com", "", 1, 45, 0, "12h-14h/18h-22h Lun à Sam", 0.0, 0.0);
    var user =  User("mail@mail", "motdepasse", "Dupont", "Jean", "Visiteur", [], false, "");
    var critique = Critique(1, "moyen", restaurant,user, "11/02/2022", 3);
    expect(critique.restaurant, restaurant);
    expect(critique.date_test, "11/02/2022");
    expect(critique.id, 1);
    expect(critique.note, 3);
    expect(critique.user, user);
    expect(critique.message, "moyen");
    expect(critique.toMapLocal(), {'id': 1,
    'message': "moyen",
    'note': 3});
  });
}