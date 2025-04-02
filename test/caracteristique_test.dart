import 'package:flutter_test/flutter_test.dart';
import 'package:saemobile/models/caracteristique.dart';

void main(){
   test("test des getters sur l'objet caracteristique", (){
       Caracteristique carac = new Caracteristique(1, "acces handicapé");
       expect(carac.id, 1);
       expect(carac.carac, "acces handicapé");

   });
}