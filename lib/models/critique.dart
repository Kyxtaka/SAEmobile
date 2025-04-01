import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/UI/review/imagedetails.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/models/restaurant.dart';
import 'package:saemobile/models/user.dart';
import 'package:flutter/material.dart';

import '../api/viewsmodel/critiquesviewmodel.dart';

class Critique {
  final int _id;
  String _message;
  final Restaurant? _restaurant;
  final User? _user;
  final String _date_test;
  int _note;
  Image? _image = null;

  Critique(
      this._id,
      this._message,
      this._restaurant,
      this._user,
      this._date_test,
      this._note);

  int get id => _id;

  String get message => _message;

  Restaurant? get restaurant => _restaurant;

  User? get user => _user;

  String get date_test => _date_test;

  int get note => _note;

  void debugPrint() {
    String critique = "id: $_id, message: $_message, restaurant: $_restaurant, user: $_user, date_test: $_date_test, note: $_note";
    print(critique);
  }

  Map<String, Object?> toMapLocal() {
    return {
      'id': _id,
      'message': _message,
      'note': _note
    };
  }

  String toString(){
    return "review ${id}, message ${message}, ${date_test}, ${note}";
  }

  set message(String value) {
    _message = value;
  }
  set note(int value) {
    _note = value;
  }


  Image get image => _image ?? Image.asset('assets/img/default-image.png');

  set image(Image value) {
    _image = value;
  }

  Future<void> getCritiqueImageIfExist() async {
    final result = await CritiqueAPI.getPhotoCritique(id);
    if (result != null)  {
      image = result;
      imagePath = "";
    }

  }

  String? _imagePath;

  String get imagePath => _imagePath ?? 'assets/img/default-image.png';

  set imagePath(String value) {
    _imagePath = value;
  }

  Widget renderCard(BuildContext context, bool? publicMode) {
    if (publicMode != null) publicMode = publicMode;
    else {
      publicMode = true;
    }
    if (imagePath != 'assets/img/default-image.png') {
      return renderCardImage(context, publicMode);
    }else {
      return renderCardSimple(context, publicMode);
    }
  }

  Widget renderCardImage(BuildContext context, bool? publicMode) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: (publicMode!) ? Text("${user!.prenom} ${user!.nom} à critiqué ${restaurant!.name} le ${date_test}") : Text('Vous avez critiqué ${restaurant!.name} le ${date_test}',),
        leading: ImageDetail(image: image,),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBarIndicator(
              rating: note.toDouble(),
              itemBuilder: (context, index) =>
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
              itemCount: 5,
              itemSize: 12.0,
              direction: Axis.horizontal,
            ),
            SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            (publicMode!) ? Container() :
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 15,
                    color: Colors.red,
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      print("image url : ${image}");
                      bool isDeleted = await Provider.of<CritiqueViewModel>(context, listen: false).deleteCritique(this, true);
                      if (!isDeleted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Erreur : impossible de supprimer la review photo"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  IconButton(
                    iconSize: 20,
                    color: Colors.grey,
                    icon: const Icon(Icons.edit),
                    onPressed: () => context.go('/avis/${id}'),
                  ),
                  IconButton(
                      iconSize: 20,
                      color: Colors.grey,
                      onPressed: () {
                        context.go('/details/${restaurant?.id}');
                      },
                      icon: Icon(Icons.restaurant))
                ]
            ),
          ],
        ),
      ),
    );
  }

  Widget renderCardSimple(BuildContext context,  bool? publicMode) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: (publicMode!) ? Text("${user!.prenom} ${user!.nom} à critiqué ${restaurant!.name} le ${date_test}") : Text('Vous avez critiqué ${restaurant!.name} le ${date_test}',),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBarIndicator(
              rating: note.toDouble(),
              itemBuilder: (context, index) =>
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
              itemCount: 5,
              itemSize: 24.0,
              direction: Axis.horizontal,
            ),
            SizedBox(height: 5),
            Text(
              message,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            (publicMode!) ? Container() :
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 20,
                    color: Colors.red,
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      print("image url : ${image}");
                      bool isDeleted = await Provider.of<CritiqueViewModel>(context, listen: false).deleteCritique(this, false);
                      if (!isDeleted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Erreur : impossible de supprimer la review"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  IconButton(
                    iconSize: 20,
                    color: Colors.grey,
                    icon: const Icon(Icons.edit),
                    onPressed: () => context.go('/avis/${id}'),
                  ),
                  IconButton(
                      iconSize: 20,
                      color: Colors.grey,
                      onPressed: () {
                        context.go('/details/${restaurant?.id}');
                      },
                      icon: Icon(Icons.restaurant))
                ]
            ),
          ],
        ),
      ),
    );
  }
}