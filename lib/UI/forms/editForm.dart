import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/api/viewsmodel/critiquesviewmodel.dart';
import 'package:saemobile/models/critique.dart';

import '../global/footer.dart';

class EditForm extends StatefulWidget {
  final String? id;
  const EditForm({super.key, required this.id});

  @override
  State<EditForm> createState() {
    return _EditFormState();
  }
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late var _noteController;

  @override
  Widget build(BuildContext context) {
    Header header = new Header();
    Footer footer = new Footer();
    return Scaffold(
      appBar: header.create(),
      bottomNavigationBar: footer.create(context),
      body : FutureBuilder<Critique?>(
        future: CritiqueAPI.getCritique(widget.id),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();

        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (snapshot.hasData) {
            _noteController = snapshot.data?.note.toDouble();
    return FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Modifier votre critique", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30), ),
            SizedBox(height: 20),
            FormBuilderTextField(
                name: 'Avis',
                initialValue: snapshot.data?.message,
                decoration: InputDecoration(
                  labelText: 'Avis',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.7)),
                  ),
                validator: (value) => value!.isEmpty ? 'Veuillez donner un avis' : null,
              ),
            SizedBox(height: 20),
                Text("Votre note"),

                RatingBar.builder(
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _noteController = rating;
                  },
                ),
            SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save(),
                  context.read<CritiqueViewModel>().editCritique(
                      snapshot.data?.id ?? 3,
                      _formKey.currentState?.fields['Avis']?.value,
                      _noteController)
                  },
                  context.go('/avis')
                  },
                child: Text("Sauvegarder"))
              ],

              ));
          }
          return Text("Error");})

    );
    }
  }

