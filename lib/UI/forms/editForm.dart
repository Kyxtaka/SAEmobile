import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/viewsmodel/critiquesviewmodel.dart';
import 'package:saemobile/models/critique.dart';

import '../global/footer.dart';

class EditForm extends StatefulWidget {
  final Critique avis;
  const EditForm({super.key, required this.avis});

  @override
  State<EditForm> createState() {
    return _EditFormState();
  }
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    Header header = new Header();
    Footer footer = new Footer();
    return Scaffold(
      appBar: header.create(),
      bottomNavigationBar: footer.create(context),
      body : FormBuilder(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            key: _formKey,
            children: [
              FormBuilderTextField(
                name: 'Avis',
                initialValue: widget.avis.message??"",
                decoration: InputDecoration(
                  labelText: 'Avis',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.7)),
                ),
                validator: (value) => value!.isEmpty ? 'Veuillez donner un avis' : null,
              ),
              ElevatedButton(
                  onPressed: () => {
                  if (_formKey.currentState!.validate()) {
                    context.read<CritiqueViewModel>().editCritique(
                      widget.avis.id, widget.avis.message, widget.avis.note)
                    },
                  Navigator.pop(context)
                  },
                  child: Text("Sauvegarder"))

            ],

          ))

    );
  }

}
