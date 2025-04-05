

import 'package:flutter_test/flutter_test.dart';
import 'package:saemobile/models/user.dart';

void main() {
  test("Test des getters sur l'objet User", (){
    var user =  User("mail@mail", "motdepasse", "Dupont", "Jean", "Visiteur", [], false, "");
    expect(user.connected, false);
    expect(user.mail, "mail@mail");
    expect(user.password, "motdepasse");
    expect(user.localisation, "");
    expect(user.nom, "Dupont");
    expect(user.prenom, "Jean");
    expect(user.role, "Visiteur");
    expect(user.tester, []);
    expect(user.toMapLocal(), {'mail': "mail@mail",
        'connected': false,
        'localisation': ""});

    expect(user.role, isNot("admin"));
    expect(user.prenom, isNot("Francis"));
  });
}