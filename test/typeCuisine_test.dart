

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:saemobile/models/typeCuisine.dart';

void main(){
   test("test des getters sur l'objet typeCuisine", (){
       var typecuisine = new TypeCuisine(1, "du monde", "");
       expect(typecuisine.id, 1);
       expect(typecuisine.cuisine, "du monde");
       expect(typecuisine.toMapLocal(), {'idCuisine': 1,
         'nomCuisine': "du monde", 'imgCuisine':''});
   });
}