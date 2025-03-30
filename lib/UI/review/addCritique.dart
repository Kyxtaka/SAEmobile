import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:saemobile/UI/global/footer.dart';
import 'package:saemobile/UI/global/header.dart';
import 'package:saemobile/api/critiqueapi.dart';
import 'package:saemobile/api/viewsmodel/userviewmodel.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  late var _noteController;

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
                                  (_noteController + 0.5).toInt() ?? 3,
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