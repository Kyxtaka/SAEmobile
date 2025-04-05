import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:saemobile/models/caracteristique.dart';
import 'package:saemobile/models/typeCuisine.dart';
class DropdownTypeCuisine extends StatelessWidget {
  final List<TypeCuisine> typeCuisines;
  final ValueChanged<TypeCuisine?> onChanged;
  final TypeCuisine? selectedType;


  const DropdownTypeCuisine({
    super.key,
    required this.typeCuisines,
    required this.onChanged,
    this.selectedType,

  });



  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<TypeCuisine>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.deepOrangeAccent,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                'Sélectionnez un type de cuisine',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: typeCuisines.map<DropdownMenuItem<TypeCuisine>>(
              (TypeCuisine item) {
                return DropdownMenuItem<TypeCuisine>(
                    value: item,
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                              item.cuisine,
                              style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                      ),
                          overflow: TextOverflow.ellipsis,
                          ),
                      ),
                      ],
                  ),
                );
          },
        ).toList(),
        value: selectedType,
        onChanged: onChanged,
      ),
    );
  }
}


class DropdownCaracteristique extends StatelessWidget {
  final List<Caracteristique> caracteristiques;
  final ValueChanged<Caracteristique?> onChanged;
  final Caracteristique? selectedCarac;

  const DropdownCaracteristique({
    super.key,
    required this.caracteristiques,
    required this.onChanged,
    this.selectedCarac,
  });


  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<Caracteristique>(
        isExpanded: true,
        hint: selectedCarac == null
            ? const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.deepOrangeAccent,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                'Sélectionnez une caractéristique',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )
            : Text(
          selectedCarac!.carac,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        items: caracteristiques.map<DropdownMenuItem<Caracteristique>>(
              (Caracteristique item) {
            return DropdownMenuItem<Caracteristique>(
              value: item,
              child: Text(
                item.carac,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ).toList(),
        value: selectedCarac,
        onChanged: onChanged,
      ),
    );
  }
}

class DropdownTypeCuisineFavoris extends StatelessWidget {
  final List<TypeCuisine> typeCuisines;
  final ValueChanged<TypeCuisine?> onChanged;
  final TypeCuisine? selectedType;
  final ValueChanged<TypeCuisine>? onRemove;

  const DropdownTypeCuisineFavoris({
    super.key,
    required this.typeCuisines,
    required this.onChanged,
    this.selectedType,
    this.onRemove,
  });

  Widget addBoutonDelete(item){
    var button = null;
    if (typeCuisines.contains(item)){
      var button =IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          onRemove!(item);
        },
      );
    }
    else {
      var button = IconButton(
        icon: Icon(Icons.add, color: Colors.green),
        onPressed: () {
        },
      );
    }
    return Row(
      children: [
        Expanded(
          child: Text(
            item.cuisine,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        button
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<TypeCuisine>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.deepOrangeAccent,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                'Sélectionnez un type de cuisine',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: typeCuisines.map<DropdownMenuItem<TypeCuisine>>(
              (TypeCuisine item) {
            return DropdownMenuItem<TypeCuisine>(
              value: item,
              child: addBoutonDelete(item)
            );
          },
        ).toList(),
        value: selectedType,
        onChanged: onChanged,
      ),
    );
  }
}