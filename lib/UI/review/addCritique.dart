import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
class AddCritiquePage extends StatefulWidget {

  final int restID;

  const AddCritiquePage({super.key, required this.restID});

  @override
  State<AddCritiquePage> createState() => _AddCritiquePageState();
}

class _AddCritiquePageState extends State<AddCritiquePage> {

  late Future<void> _loadDataFuture;
  late String user_identifier;

  @override
  void initState() {
    super.initState();
     _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    final identifier = await UserViewModel.getCurrentUser();
    user_identifier = identifier;
  }


  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.create(),
      bottomNavigationBar: Footer().create(context),
      body: FutureBuilder(
          future: _loadDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator(),);
            }

            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            bool show = false;

            if (show) return Center(child: Text("data resstID: ${widget.restID} user_identifier: $user_identifier"),);

            return Center(
              child: FormBuilder(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(16.5),
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'Message',
                          decoration: const InputDecoration(labelText: 'Messsage'),
                          validator:
                          FormBuilderValidators.compose([
                            FormBuilderValidators.required()
                          ]),
                        ),
                        FormBuilderTextField(
                          name: 'Note',
                          decoration: const InputDecoration(labelText: 'Note'),
                          validator:
                          FormBuilderValidators.compose([
                            FormBuilderValidators.required()
                          ]),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 20),
                                backgroundColor: Colors.purple
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()){

                                CritiqueAPI.insertCritique(
                                  widget.restID.toString(),
                                  user_identifier,
                                  _formKey.currentState?.fields['Message']?.value,
                                  int.parse(_formKey.currentState?.fields['Note']?.value),
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Ajouter')
                        )
                      ],
                    ),
                  )
              ),
            );

          }
      ),
    );
  }
}