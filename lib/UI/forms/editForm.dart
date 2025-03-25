import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/api/viewsmodel/critiquesviewmodel.dart';
import 'package:saemobile/models/critique.dart';

import '../global/footer.dart';

class EditForm extends StatefulWidget {
  final int id;
  const EditForm({super.key, required this.id});

  @override
  State<EditForm> createState() {
    return _EditFormState();
  }
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<Critique?> getCritique(id) async {
    Critique? avis = await CritiqueAPI.getCritique(widget.id);
    return avis;
  }

  @override
  Widget build(BuildContext context) {
    var avis = getCritique(widget.id);
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
    return FormBuilder(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      key: _formKey,
      children: [
      FormBuilderTextField(
        name: 'Avis',
        initialValue: "",
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
        0, "avis.message", "avis.note")
        },
        Navigator.pop(context)
        },
      child: Text("Sauvegarder"))
    ],

    ));
    }
          return Text("Error");})

    );
    }
  }

